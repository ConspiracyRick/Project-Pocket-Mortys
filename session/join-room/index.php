<?php
// join-room.php

error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

header("Content-Type: application/json; charset=utf-8");

require __DIR__ . "/../../pocket_f4894h398r8h9w9er8he98he.php";
require_once __DIR__ . "/../../lib/events.php";
require_once __DIR__ . "/../../lib/room_entities.php";

$body = json_decode(file_get_contents("php://input"), true) ?: [];
$session_id = (string)($body["session_id"] ?? "");
$world_id   = (string)($body["world_id"] ?? "");

// optional: allow client to request a specific room_id
$requested_room_id = isset($body["room_id"]) ? (string)$body["room_id"] : "";

if ($session_id === "" || $world_id === "") {
  http_response_code(400);
  echo json_encode(["error" => "Missing session_id or world_id"], JSON_UNESCAPED_SLASHES);
  exit;
}

// --- Auth: session_id -> user ---
$stmt = $pdo->prepare("
  SELECT player_id, username, player_avatar_id, level
  FROM users
  WHERE session_id = ?
  LIMIT 1
");
$stmt->execute([$session_id]);
$me = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$me) {
  http_response_code(401);
  echo json_encode(["error" => "Not authenticated"], JSON_UNESCAPED_SLASHES);
  exit;
}

$my_player_id = (string)$me["player_id"];

// ------------------------------------------------------------
// Choose room from room_ids ONLY
// ------------------------------------------------------------

// Helper: fetch a room row by room_id
function fetch_room_row(PDO $pdo, string $room_id): ?array {
  $q = $pdo->prepare("
    SELECT room_id, room_udp_host, room_udp_port
    FROM room_ids
    WHERE room_id = ?
    LIMIT 1
  ");
  $q->execute([$room_id]);
  $r = $q->fetch(PDO::FETCH_ASSOC);
  return $r ? $r : null;
}

// Option A: if client requested a room_id and it exists, use it
$roomRow = null;
if ($requested_room_id !== "") {
  // room_id is bigint in DB, but clients may send string; MySQL will cast safely if numeric
  $roomRow = fetch_room_row($pdo, $requested_room_id);
  if (!$roomRow) {
    http_response_code(404);
    echo json_encode(["error" => "Requested room_id not found"], JSON_UNESCAPED_SLASHES);
    exit;
  }
}

// Option B: choose least populated room (based on users in that room seen in last 5 minutes)
if (!$roomRow) {
  $q = $pdo->prepare("
    SELECT r.room_id, r.room_udp_host, r.room_udp_port
    FROM room_ids r
    LEFT JOIN users u
      ON u.room_id = r.room_id
     AND u.last_seen >= (NOW() - INTERVAL 5 MINUTE)
    GROUP BY r.room_id, r.room_udp_host, r.room_udp_port
    ORDER BY COUNT(u.player_id) ASC, r.room_id ASC
    LIMIT 1
  ");
  $q->execute();
  $roomRow = $q->fetch(PDO::FETCH_ASSOC);

  if (!$roomRow) {
    http_response_code(500);
    echo json_encode(["error" => "No rooms available (room_ids empty)"], JSON_UNESCAPED_SLASHES);
    exit;
  }
}

$room_id = (string)$roomRow["room_id"];
$room_udp_host = (string)($roomRow["room_udp_host"] ?? "");
$room_udp_port = (string)($roomRow["room_udp_port"] ?? "");

// zone_id logic (still placeholder; you can replace with real zone picking)
$zone_id = "[13-15]";

// ------------------------------------------------------------
// Update presence in users table
// ------------------------------------------------------------
$up = $pdo->prepare("
  UPDATE users
  SET
    room_id = ?,
    username = ?,
    player_avatar_id = ?,
    level = ?,
    state = 'WORLD',
    last_seen = NOW()
  WHERE player_id = ?
  LIMIT 1
");

$up->execute([
  $room_id,
  (string)$me["username"],
  (string)$me["player_avatar_id"],
  (int)$me["level"],
  $my_player_id,
]);

// ✅ If nothing changed, it might still be fine (values already identical).
if ($up->rowCount() === 0) {
  // Check if player_id actually exists
  $chk = $pdo->prepare("SELECT 1 FROM users WHERE player_id = ? LIMIT 1");
  $chk->execute([$my_player_id]);
  $exists = (bool)$chk->fetchColumn();

  if (!$exists) {
    http_response_code(500);
    echo json_encode(["error" => "User row not found for player_id"], JSON_UNESCAPED_SLASHES);
    exit;
  }

  // Otherwise: row exists and update was a no-op → success
}

// ------------------------------------------------------------
// Ensure room has initial entities (may publish events)
// ------------------------------------------------------------
if (!room_is_initialized($pdo, $room_id)) {
  seed_room_entities($pdo, $room_id, $world_id, $zone_id);
}

// ------------------------------------------------------------
// Baseline cursor AFTER seeding
// Store baseline in users.last_event_id (room_stream_cursor removed)
// ------------------------------------------------------------
$maxBefore = $pdo->prepare("SELECT COALESCE(MAX(id), 0) FROM event_queue WHERE room_id = ?");
$maxBefore->execute([$room_id]);
$baseline_event_id = (int)$maxBefore->fetchColumn();

$pdo->prepare("
  UPDATE users
  SET last_event_id = ?, last_seen = NOW(), room_id = ?
  WHERE player_id = ?
  LIMIT 1
")->execute([$baseline_event_id, $room_id, $my_player_id]);

// ------------------------------------------------------------
// Snapshot: users currently in this room
// (include only users seen in last 5 minutes to avoid ghosts)
// ------------------------------------------------------------
$pres = $pdo->prepare("
  SELECT player_id, username, player_avatar_id, level, state
  FROM users
  WHERE room_id = ?
    AND last_seen >= (NOW() - INTERVAL 5 MINUTE)
  ORDER BY last_seen DESC
");
$pres->execute([$room_id]);
$present_users = $pres->fetchAll(PDO::FETCH_ASSOC);

// Incentive (safe default)
$incentive = [
  "incentive_id" => "NPCAd",
  "rewards" => [
    ["type" => "ITEM", "amount" => 1, "item_id" => "ItemSerum", "rarity" => 100],
    ["type" => "ITEM", "amount" => 1, "item_id" => "ItemParalysisCure", "rarity" => 75],
    ["type" => "COIN", "amount" => 200],
  ],
  "token" => ""
];

// Build morties map for everyone in room
$player_ids = array_values(array_unique(array_map(fn($r) => (string)$r["player_id"], $present_users)));
$morties_by_player = [];

if (count($player_ids) > 0) {
  $placeholders = implode(",", array_fill(0, count($player_ids), "?"));
  $mstmt = $pdo->prepare("
    SELECT
      player_id,
      owned_morty_id,
      morty_id,
      hp,
      variant,
      is_locked,
      is_trading_locked,
      fight_pit_id
    FROM owned_morties
    WHERE player_id IN ($placeholders)
    ORDER BY id ASC
  ");
  $mstmt->execute($player_ids);

  while ($m = $mstmt->fetch(PDO::FETCH_ASSOC)) {
    $pid = (string)$m["player_id"];
    if (!isset($morties_by_player[$pid])) $morties_by_player[$pid] = [];

    $is_locked = ($m["is_locked"] === "true" || $m["is_locked"] === "1" || $m["is_locked"] === 1);
    $is_trading_locked = ($m["is_trading_locked"] === "true" || $m["is_trading_locked"] === "1" || $m["is_trading_locked"] === 1);

    $morties_by_player[$pid][] = [
      "owned_morty_id" => (string)$m["owned_morty_id"],
      "morty_id" => (string)$m["morty_id"],
      "hp" => (int)$m["hp"],
      "variant" => $m["variant"] ?: "Normal",
      "is_locked" => (bool)$is_locked,
      "is_trading_locked" => (bool)$is_trading_locked,
      "fight_pit_id" => ($m["fight_pit_id"] === null || $m["fight_pit_id"] === "null") ? null : (string)$m["fight_pit_id"]
    ];
  }
}

// Assemble users array
$users = [];
foreach ($present_users as $u) {
  $pid = (string)$u["player_id"];
  $users[] = [
    "player_id" => $pid,
    "username" => (string)$u["username"],
    "player_avatar_id" => (string)$u["player_avatar_id"],
    "level" => (int)$u["level"],
    "owned_morties" => $morties_by_player[$pid] ?? [],
    "state" => ($u["state"] ?: "WORLD")
  ];
}

// Snapshot from events
$entities = build_room_snapshot_from_events($pdo, $room_id);

// Announce join to everyone else
publish_event($pdo, $room_id, "room:user-added", [
  "player_id" => $my_player_id,
  "username" => (string)$me["username"],
  "player_avatar_id" => (string)$me["player_avatar_id"],
  "level" => (int)$me["level"],
  "owned_morties" => $morties_by_player[$my_player_id] ?? [],
  "state" => "WORLD"
]);

$response = [
  "room_id" => $room_id,
  "room_udp_host" => $room_udp_host,
  "room_udp_port" => $room_udp_port,
  "world_id" => $world_id,
  "zone_id" => $zone_id,
  "incentive" => $incentive,
  "users" => $users,
  "pickups" => $entities["pickups"] ?? [],
  "wild_morties" => $entities["wild_morties"] ?? [],
  "bots" => $entities["bots"] ?? [],
  "baseline_event_id" => $baseline_event_id
];

echo json_encode($response, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
