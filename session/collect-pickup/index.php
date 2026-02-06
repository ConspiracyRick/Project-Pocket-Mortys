<?php
// collect-pickup

header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Origin: *");

require __DIR__ . "/../../pocket_f4894h398r8h9w9er8he98he.php";
require __DIR__ . "/../../lib/events.php";

// ---------- helpers ----------
function uuidv4(): string {
  $data = random_bytes(16);
  $data[6] = chr((ord($data[6]) & 0x0f) | 0x40);
  $data[8] = chr((ord($data[8]) & 0x3f) | 0x80);
  return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}

function weighted_pick(array $choices) {
  $total = 0;
  foreach ($choices as $c) $total += (int)$c["weight"];
  $roll = random_int(1, max(1, $total));
  $acc = 0;
  foreach ($choices as $c) {
    $acc += (int)$c["weight"];
    if ($roll <= $acc) return $c["value"];
  }
  return $choices[count($choices) - 1]["value"];
}

function pick_rarity(): int {
  return (int) weighted_pick([
    ["value" => 5,   "weight" => 55],
    ["value" => 75,  "weight" => 30],
    ["value" => 100, "weight" => 15],
  ]);
}

function loot_table_by_rarity(): array {
  return [
    5 => ["ItemMegaSeedSpeed","ItemTinCan","ItemCircuitBoard","ItemCable","ItemPlutonicRock","ItemBacteriaCell"],
    75 => ["ItemPoisonCure","ItemCable","ItemCircuitBoard"],
    100 => ["ItemSerum","ItemDarkEnergyBall","ItemCircuitBoard","ItemPlutonicRock"],
  ];
}

function pick_item_id(int $rarity, array $excludeItemIds = []): string {
  $table = loot_table_by_rarity();
  $pool = $table[$rarity] ?? ["ItemCircuitBoard"];

  if (!empty($excludeItemIds)) {
    $filtered = array_values(array_diff($pool, $excludeItemIds));
    if (!empty($filtered)) $pool = $filtered;
  }

  return $pool[array_rand($pool)];
}

function pick_random_placement_like_examples(PDO $pdo, string $room_id): array {
  $minX = 1; $maxX = 80;
  $minY = 1; $maxY = 80;

  $stmt = $pdo->prepare("
    SELECT payload_json
    FROM event_queue
    WHERE room_id = ?
      AND event_name = 'room:pickup-added'
    ORDER BY id DESC
    LIMIT 250
  ");
  $stmt->execute([$room_id]);

  $occupied = [];
  while ($r = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $p = json_decode((string)$r["payload_json"], true);
    if (is_array($p) && isset($p["placement"][0], $p["placement"][1])) {
      $x = (int)$p["placement"][0];
      $y = (int)$p["placement"][1];
      $occupied["$x,$y"] = true;
    }
  }

  for ($i = 0; $i < 50; $i++) {
    if (random_int(1, 100) <= 70) {
      $x = random_int(45, $maxX);
      $y = random_int(35, $maxY);
    } else {
      $x = random_int($minX, $maxX);
      $y = random_int($minY, $maxY);
    }

    if (!isset($occupied["$x,$y"])) return [$x, $y];
  }

  return [random_int($minX, $maxX), random_int($minY, $maxY)];
}

function random_pickup_contents(array $excludeItemIds = []): array {
  // Never COIN-only:
  // - single ITEM (no coin)
  // - bundle: 2-4 ITEMs + COIN
  $kind = weighted_pick([
    ["value" => "single", "weight" => 70],
    ["value" => "bundle", "weight" => 30],
  ]);

  if ($kind === "single") {
    $r = pick_rarity();
    $item = pick_item_id($r, $excludeItemIds);
    return [
      ["type" => "ITEM", "amount" => 1, "item_id" => $item, "rarity" => $r]
    ];
  }

  $nItems = random_int(2, 4);
  $contents = [];
  $picked = [];

  for ($i = 0; $i < $nItems; $i++) {
    $r = pick_rarity();
    $item = pick_item_id($r, array_merge($excludeItemIds, $picked));
    $picked[] = $item;
    $contents[] = ["type" => "ITEM", "amount" => 1, "item_id" => $item, "rarity" => $r];
  }

  $contents[] = ["type" => "COIN", "amount" => random_int(120, 250)];
  return $contents;
}

function make_random_pickup(PDO $pdo, string $room_id, array $excludeItemIds = []): array {
  return [
    "contents"  => random_pickup_contents($excludeItemIds),
    "placement" => pick_random_placement_like_examples($pdo, $room_id),
    "pickup_id" => uuidv4(),
  ];
}

// ---------- input ----------
$body = json_decode(file_get_contents("php://input"), true) ?: [];
$session_id = (string)($body["session_id"] ?? "");
$pickup_id  = (string)($body["pickup_id"] ?? "");

if ($session_id === "" || $pickup_id === "") {
  http_response_code(400);
  echo json_encode(["error" => "Missing session_id or pickup_id"], JSON_UNESCAPED_SLASHES);
  exit;
}

try {
  $pdo->beginTransaction();

  // 1) player + room
  $stmt = $pdo->prepare("
    SELECT player_id, room_id
    FROM users
    WHERE session_id = ?
    LIMIT 1
  ");
  $stmt->execute([$session_id]);
  $player = $stmt->fetch(PDO::FETCH_ASSOC);

  if (!$player) {
    $pdo->rollBack();
    http_response_code(401);
    echo json_encode(["error" => "Not authenticated"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  $player_id = (string)$player["player_id"];
  $room_id   = (string)$player["room_id"];

  if ($room_id === "" || $room_id === "0") {
    $pdo->rollBack();
    http_response_code(409);
    echo json_encode(["error" => "Player is not in a room"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  // 2) Find the pickup spawn row (fast: pickup_id column), lock it
  $stmt = $pdo->prepare("
    SELECT id, payload_json, pickup_id_collected_by_player_id
    FROM event_queue
    WHERE room_id = ?
      AND event_name = 'room:pickup-added'
      AND pickup_id = ?
    ORDER BY id DESC
    LIMIT 1
    FOR UPDATE
  ");
  $stmt->execute([$room_id, $pickup_id]);
  $spawnRow = $stmt->fetch(PDO::FETCH_ASSOC);

  if (!$spawnRow) {
    $pdo->rollBack();
    http_response_code(404);
    echo json_encode(["error" => "Pickup not found in this room"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  if (!empty($spawnRow["pickup_id_collected_by_player_id"])) {
    $pdo->rollBack();
    http_response_code(409);
    echo json_encode(["error" => "Pickup already collected"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  $spawnPayload = json_decode((string)$spawnRow["payload_json"], true);
  if (!is_array($spawnPayload) || empty($spawnPayload["contents"]) || !is_array($spawnPayload["contents"])) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["error" => "Pickup payload malformed"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  // Avoid spawning identical items immediately
  $exclude = [];
  foreach ($spawnPayload["contents"] as $c) {
    if (is_array($c) && (($c["type"] ?? "") === "ITEM") && !empty($c["item_id"])) {
      $exclude[] = (string)$c["item_id"];
    }
  }

  // 3) Mark collected
  $spawnId = (int)$spawnRow["id"];
  $upd = $pdo->prepare("
    UPDATE event_queue
    SET pickup_id_collected_by_player_id = ?
    WHERE id = ?
      AND room_id = ?
      AND pickup_id_collected_by_player_id IS NULL
  ");
  $upd->execute([$player_id, $spawnId, $room_id]);

  if ($upd->rowCount() !== 1) {
    $pdo->rollBack();
    http_response_code(409);
    echo json_encode(["error" => "Pickup already collected"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  // 4) Broadcast removed (this inserts a new event row)
  publish_event($pdo, (string)$room_id, "room:pickup-removed", [
    "pickup_id" => (string)$pickup_id
  ]);

  // 5) Spawn ONE new pickup
  $newPickup = make_random_pickup($pdo, (string)$room_id, $exclude);
  publish_event($pdo, (string)$room_id, "room:pickup-added", $newPickup);

  $pdo->commit();

  // 6) Response = actual contents picked up
  echo json_encode([
    "pickup_id" => (string)$pickup_id,
    "contents"  => $spawnPayload["contents"]
  ], JSON_UNESCAPED_SLASHES);

} catch (Throwable $e) {
  if ($pdo->inTransaction()) $pdo->rollBack();
  http_response_code(500);
  echo json_encode(["error" => "Server error", "detail" => $e->getMessage()], JSON_UNESCAPED_SLASHES);
}
