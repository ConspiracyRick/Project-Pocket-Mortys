<?php
// collect-pickup  (updates items + coins, returns totals like client expects)

error_reporting(E_ALL);
ini_set('display_errors', 1);

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
    5   => ["ItemMegaSeedSpeed","ItemTinCan","ItemCircuitBoard","ItemCable","ItemPlutonicRock","ItemBacteriaCell"],
    75  => ["ItemPoisonCure","ItemCable","ItemCircuitBoard"],
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

const PICKUP_SPAWN_POINTS = [
  [25,87],
  [34,83],
  [42,64],
  [48,87],
  [57,48],
  [65,79],
];

function pick_placement_from_hardcoded_points(PDO $pdo, string $room_id): array {
  $stmt = $pdo->prepare("
    SELECT payload_json
    FROM event_queue
    WHERE room_id = ?
      AND event_name = 'room:pickup-added'
      AND pickup_id_collected_by_player_id IS NULL
    ORDER BY id DESC
    LIMIT 500
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

  $available = [];
  foreach (PICKUP_SPAWN_POINTS as $pt) {
    $key = $pt[0] . "," . $pt[1];
    if (!isset($occupied[$key])) $available[] = $pt;
  }

  if (empty($available)) $available = PICKUP_SPAWN_POINTS;

  return $available[array_rand($available)];
}

/**
 * Spawn payload should NOT embed player totals.
 * We store only what the pickup gives ("amount").
 * Totals are computed on collect.
 */
function random_pickup_contents(array $excludeItemIds = []): array {
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

  $coinEarned = random_int(120, 250);
  $contents[] = ["type" => "COIN", "amount" => $coinEarned];

  return $contents;
}

function make_random_pickup(PDO $pdo, string $room_id, array $excludeItemIds = []): array {
  return [
    "contents"  => random_pickup_contents($excludeItemIds),
    "placement" => pick_placement_from_hardcoded_points($pdo, $room_id),
    "pickup_id" => uuidv4(),
  ];
}

// ---------- DB grant helpers ----------
const MAX_ITEM_QUANTITY = 10;

function grantItemCapped(PDO $pdo, string $player_id, string $item_id, int $addQty): array {
  $st = $pdo->prepare("SELECT id, quantity FROM owned_items WHERE player_id = ? AND item_id = ? LIMIT 1");
  $st->execute([$player_id, $item_id]);
  $row = $st->fetch(PDO::FETCH_ASSOC);

  $cur = $row ? (int)$row["quantity"] : 0;

  if ($cur >= MAX_ITEM_QUANTITY || $addQty <= 0) {
    return [
      "type" => "ITEM",
      "item_id" => $item_id,
      "quantity" => $cur,
      "amount_received" => 0,
      "amount" => 1
    ];
  }

  $target = min(MAX_ITEM_QUANTITY, $cur + $addQty);
  $added = max(0, $target - $cur);

  if ($row) {
    if ($added > 0) {
      $up = $pdo->prepare("UPDATE owned_items SET quantity = ? WHERE id = ?");
      $up->execute([$target, (int)$row["id"]]);
    }
  } else {
    if ($added > 0) {
      $ins = $pdo->prepare("INSERT INTO owned_items (player_id, item_id, quantity) VALUES (?, ?, ?)");
      $ins->execute([$player_id, $item_id, $target]);
    }
  }

  return [
    "type" => "ITEM",
    "item_id" => $item_id,
    "quantity" => $target,
    "amount_received" => $added,
    "amount" => 1
  ];
}

function grantCoins(PDO $pdo, string $player_id, int $add): array {
  if ($add <= 0) {
    $st = $pdo->prepare("SELECT coins FROM users WHERE player_id = ? LIMIT 1");
    $st->execute([$player_id]);
    $cur = (int)($st->fetchColumn() ?: 0);
    return [
      "type" => "COIN",
      "quantity" => $cur,
      "amount_received" => 0,
      "amount" => 0
    ];
  }

  $up = $pdo->prepare("UPDATE users SET coins = coins + ? WHERE player_id = ?");
  $up->execute([$add, $player_id]);

  $st = $pdo->prepare("SELECT coins FROM users WHERE player_id = ? LIMIT 1");
  $st->execute([$player_id]);
  $new = (int)($st->fetchColumn() ?: 0);

  return [
    "type" => "COIN",
    "quantity" => $new,
    "amount_received" => $add,
    "amount" => $add
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

  // 1) player + room + coins
  $stmt = $pdo->prepare("
    SELECT player_id, room_id, coins
    FROM users
    WHERE session_id = ?
    LIMIT 1
    FOR UPDATE
  ");
  $stmt->execute([$session_id]);
  $player = $stmt->fetch(PDO::FETCH_ASSOC);

  if (!$player) {
    $pdo->rollBack();
    http_response_code(401);
    echo json_encode(["error" => "Not authenticated"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  $player_id    = (string)$player["player_id"];
  $room_id      = (string)$player["room_id"];

  if ($room_id === "" || $room_id === "0") {
    $pdo->rollBack();
    http_response_code(409);
    echo json_encode(["error" => "Player is not in a room"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  // 2) lock the pickup spawn row
  $stmt = $pdo->prepare("
    SELECT id, payload_json, pickup_id, pickup_id_collected_by_player_id
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
  $pickup_id = $spawnRow['pickup_id'];
  
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

  // 4) apply rewards to DB + build response contents (ITEMs first, then COIN)
  $outItems = [];
  $outCoins = [];

  foreach ($spawnPayload["contents"] as $c) {
    if (!is_array($c)) continue;
    $type = (string)($c["type"] ?? "");

    if ($type === "ITEM") {
      $item_id = (string)($c["item_id"] ?? "");
      $amt = (int)($c["amount"] ?? 1);
      if ($item_id === "") continue;

      $outItems[] = grantItemCapped($pdo, $player_id, $item_id, $amt);
      continue;
    }

    if ($type === "COIN") {
      $amt = (int)($c["amount"] ?? 0);
      $outCoins[] = grantCoins($pdo, $player_id, $amt);
      continue;
    }
  }

  $outContents = array_merge($outItems, $outCoins);
  
  $del = $pdo->prepare("DELETE FROM event_queue WHERE room_id = ? AND pickup_id = ? AND event_name = 'room:pickup-added' LIMIT 1");
  $del->execute([$room_id, $pickup_id]);
  
  // 5) broadcast removed
  publish_event($pdo, (string)$room_id, "room:pickup-removed", [
    "pickup_id" => (string)$pickup_id
  ]);

  // 6) spawn ONE new pickup
  $newPickup = make_random_pickup($pdo, (string)$room_id, $exclude);
  publish_event($pdo, (string)$room_id, "room:pickup-added", $newPickup);

  $pdo->commit();

  // 7) response: totals after updating DB
  echo json_encode([
    "pickup_id" => (string)$pickup_id,
    "contents"  => $outContents
  ], JSON_UNESCAPED_SLASHES);

} catch (Throwable $e) {
  if ($pdo->inTransaction()) $pdo->rollBack();
  http_response_code(500);
  echo json_encode(["error" => "Server error", "detail" => $e->getMessage()], JSON_UNESCAPED_SLASHES);
}
