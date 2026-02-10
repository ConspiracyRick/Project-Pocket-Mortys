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
$world_id_in = (string)($body["world_id"] ?? "");

// optional: allow client to request a specific room_id
//$requested_room_id = isset($body["room_id"]) ? (string)$body["room_id"] : "";

if ($session_id === "" || $world_id_in === "") {
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
// Helpers: room row + entity presence
// ------------------------------------------------------------
function fetch_room_row(PDO $pdo, string $room_id): ?array {
  $q = $pdo->prepare("
    SELECT room_id, room_udp_host, room_udp_port, world_id, zone_id
    FROM room_ids
    WHERE room_id = ?
    LIMIT 1
  ");
  $q->execute([$room_id]);
  $r = $q->fetch(PDO::FETCH_ASSOC);
  return $r ? $r : null;
}

function room_has_entities(PDO $pdo, string $room_id): bool {
  // Fast check:
  // - any active pickup (added but not collected)
  // - OR any wild-morty-added
  // - OR any bot-added
  $st = $pdo->prepare("
    SELECT 1
    FROM event_queue
    WHERE room_id = ?
      AND (
        (event_name = 'room:pickup-added' AND pickup_id_collected_by_player_id IS NULL)
        OR event_name = 'room:wild-morty-added'
        OR event_name = 'room:bot-added'
      )
    LIMIT 1
  ");
  $st->execute([$room_id]);
  return (bool)$st->fetchColumn();
}

// ------------------------------------------------------------
// Choose room (MUST already have entities)
// ------------------------------------------------------------
$roomRow = null;

/*
// Option A: if client requested a room_id and it exists, use it ONLY if it has entities
if ($requested_room_id !== "") {
  $roomRow = fetch_room_row($pdo, $requested_room_id);
  if (!$roomRow) {
    http_response_code(404);
    echo json_encode(["error" => "Requested room_id not found"], JSON_UNESCAPED_SLASHES);
    exit;
  }
  if (!room_has_entities($pdo, (string)$roomRow["room_id"])) {
    http_response_code(400);
    echo json_encode([
      "error" => "ROOM_EMPTY",
      "detail" => "Requested room is not available.",
      "room_id" => (string)$roomRow["room_id"]
    ], JSON_UNESCAPED_SLASHES);
    exit;
  }
}
*/

if (!$roomRow) {
  $q = $pdo->prepare("
    SELECT r.room_id, r.room_udp_host, r.room_udp_port, r.world_id, r.zone_id
    FROM room_ids r
    LEFT JOIN users u
      ON u.room_id = r.room_id
     AND u.last_seen >= (NOW() - INTERVAL 5 MINUTE)
    WHERE EXISTS (
      SELECT 1
      FROM event_queue e
      WHERE e.room_id = r.room_id
        AND (
          (e.event_name = 'room:pickup-added' AND e.pickup_id_collected_by_player_id IS NULL)
          OR e.event_name = 'room:wild-morty-added'
          OR e.event_name = 'room:bot-added'
        )
      LIMIT 1
    )
    GROUP BY r.room_id, r.room_udp_host, r.room_udp_port, r.world_id, r.zone_id
    ORDER BY COUNT(u.player_id) ASC, r.room_id ASC
    LIMIT 1
  ");
  $q->execute();
  $roomRow = $q->fetch(PDO::FETCH_ASSOC);

  if (!$roomRow) {
    // No rooms have entities yet; DO NOT join an empty room.
    http_response_code(400);
    echo json_encode([
      "error" => "NO_READY_ROOMS",
      "detail" => "No rooms currently available."
    ], JSON_UNESCAPED_SLASHES);
    exit;
  }
}

$room_id = (string)$roomRow["room_id"];
$room_udp_host = (string)($roomRow["room_udp_host"] ?? "");
$room_udp_port = (string)($roomRow["room_udp_port"] ?? "");

$world_id = (string)($roomRow["world_id"] ?? "");
$zone_id  = (string)($roomRow["zone_id"] ?? "");

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

// ------------------------------------------------------------
// Baseline cursor (NO SEEDING HERE)
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

// Build morties map for everyone in room (ACTIVE DECK ONLY)
$player_ids = array_values(array_unique(array_map(fn($r) => (string)$r["player_id"], $present_users)));
$morties_by_player = [];

if (count($player_ids) > 0) {
  $placeholders = implode(",", array_fill(0, count($player_ids), "?"));

  $q = $pdo->prepare("
    SELECT
      u.player_id,
      u.active_deck_id,
      d.owned_morty_ids
    FROM users u
    LEFT JOIN decks d
      ON d.player_id = u.player_id
     AND d.deck_id  = u.active_deck_id
    WHERE u.player_id IN ($placeholders)
      AND u.last_seen >= (NOW() - INTERVAL 5 MINUTE)
  ");
  $q->execute($player_ids);

  $deck_ids_by_player = [];
  while ($r = $q->fetch(PDO::FETCH_ASSOC)) {
    $pid = (string)$r["player_id"];
    $json = $r["owned_morty_ids"] ?? "[]";
    $ids = json_decode($json, true);
    if (!is_array($ids)) $ids = [];

    $ids = array_values(array_filter(array_map(fn($x) => is_string($x) ? trim($x) : "", $ids), fn($x) => $x !== ""));
    $deck_ids_by_player[$pid] = $ids;

    if (!isset($morties_by_player[$pid])) $morties_by_player[$pid] = [];
  }

  $all_deck_owned_ids = [];
  foreach ($deck_ids_by_player as $ids) {
    foreach ($ids as $id) $all_deck_owned_ids[$id] = true;
  }
  $all_deck_owned_ids = array_keys($all_deck_owned_ids);

  if (count($all_deck_owned_ids) > 0) {
    $ph2 = implode(",", array_fill(0, count($all_deck_owned_ids), "?"));

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
      WHERE owned_morty_id IN ($ph2)
      ORDER BY id ASC
    ");
    $mstmt->execute($all_deck_owned_ids);

    $morty_row_by_owned_id = [];
    while ($m = $mstmt->fetch(PDO::FETCH_ASSOC)) {
      $oid = (string)$m["owned_morty_id"];

      $is_locked = ($m["is_locked"] === "true" || $m["is_locked"] === "1" || $m["is_locked"] === 1);
      $is_trading_locked = ($m["is_trading_locked"] === "true" || $m["is_trading_locked"] === "1" || $m["is_trading_locked"] === 1);

      $morty_row_by_owned_id[$oid] = [
        "owned_morty_id" => $oid,
        "morty_id" => (string)$m["morty_id"],
        "hp" => (int)$m["hp"],
        "variant" => $m["variant"] ?: "Normal",
        "is_locked" => (bool)$is_locked,
        "is_trading_locked" => (bool)$is_trading_locked,
        "fight_pit_id" => ($m["fight_pit_id"] === null || $m["fight_pit_id"] === "null") ? null : (string)$m["fight_pit_id"]
      ];
    }

    foreach ($deck_ids_by_player as $pid => $ids) {
      $out = [];
      foreach ($ids as $oid) {
        if (isset($morty_row_by_owned_id[$oid])) $out[] = $morty_row_by_owned_id[$oid];
      }
      $morties_by_player[$pid] = $out;
    }
  } else {
    foreach ($player_ids as $pid) {
      if (!isset($morties_by_player[$pid])) $morties_by_player[$pid] = [];
    }
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

// Snapshot from events (READ ONLY)
$entities = build_room_snapshot_from_events($pdo, $room_id);

// Announce join
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
