<?php
// battle wild morty
header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Origin: *");

error_reporting(E_ALL);
ini_set('display_errors', 1);

require __DIR__ . "/../../pocket_f4894h398r8h9w9er8he98he.php";
require_once __DIR__ . "/../../lib/events.php";

// Read body
$raw  = file_get_contents("php://input");
$body = json_decode($raw, true);

// Accept session_id from JSON body
$session_id = (string)($body["session_id"]);
if ($session_id === "") {
    http_response_code(400);
    echo json_encode(["success" => false, "error" => "Error"], JSON_UNESCAPED_SLASHES);
    exit;
}

// Accept wild_morty_id from JSON body
$wild_morty_id = (string)($body["wild_morty_id"]);
if ($wild_morty_id === "") {
    http_response_code(400);
    echo json_encode(["success" => false, "error" => "Error"], JSON_UNESCAPED_SLASHES);
    exit;
}

// 1) Lookup player + current room from users
$stmt = $pdo->prepare("
  SELECT player_id, room_id
  FROM users
  WHERE session_id = ?
  LIMIT 1
");
$stmt->execute([$session_id]);
$u = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$u) {
    http_response_code(401);
    echo json_encode(["success" => false, "error" => "Not authenticated"], JSON_UNESCAPED_SLASHES);
    exit;
}

$player_id = (string)$u["player_id"];
$room_id   = (string)($u["room_id"] ?? "");

if ($room_id === "" || $room_id === "0") {
    http_response_code(409);
    echo json_encode(["success" => false, "error" => "Player is not in a room"], JSON_UNESCAPED_SLASHES);
    exit;
}

// 2) Verify room exists in room_ids
$chk = $pdo->prepare("SELECT 1 FROM room_ids WHERE room_id = ? LIMIT 1");
$chk->execute([$room_id]);
if (!$chk->fetchColumn()) {
    http_response_code(409);
    echo json_encode(["success" => false, "error" => "Room does not exist", "room_id" => $room_id], JSON_UNESCAPED_SLASHES);
    exit;
}

// helpers
function uuidv4(): string {
    $data = random_bytes(16);
    $data[6] = chr((ord($data[6]) & 0x0f) | 0x40);
    $data[8] = chr((ord($data[8]) & 0x3f) | 0x80);
    return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}
function to_bool($v): bool {
    if (is_bool($v)) return $v;
    if ($v === null) return false;
    $s = strtolower(trim((string)$v));
    return in_array($s, ['1','true','yes','y','on'], true);
}
function parse_id_list($raw): array {
    // Handles JSON '["id1","id2"]' OR CSV 'id1,id2' AND filters blanks/nulls
    $raw = (string)$raw;
    $raw = trim($raw);

    $ids = json_decode($raw, true);
    if (is_array($ids)) {
        $out = [];
        foreach ($ids as $x) {
            $x = is_string($x) ? trim($x) : '';
            if ($x !== '') $out[] = $x;
        }
        return array_values($out);
    }

    // fallback: CSV
    $parts = array_map('trim', explode(',', $raw));
    $parts = array_values(array_filter($parts, fn($x) => $x !== ''));
    return $parts;
}

// 1) define battle (fixes undefined $battle)
$battle = [
    "battle_id"   => uuidv4(),
    "battle_type" => "PvWM",
];

function get_wild_morty_payload(PDO $pdo, string $room_id, string $wild_morty_id): ?array {
    // Get most recent wild-morty-added events and find matching wild_morty_id
    $stmt = $pdo->prepare("
        SELECT payload_json
        FROM event_queue
        WHERE room_id = ?
          AND event_name = 'room:wild-morty-added'
        ORDER BY id DESC
        LIMIT 50
    ");
    $stmt->execute([$room_id]);

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $payload = json_decode($row["payload_json"] ?? "", true);
        if (!is_array($payload)) continue;

        if ((string)($payload["wild_morty_id"] ?? "") === $wild_morty_id) {
            return $payload;
        }
    }

    return null;
}

$wildPayload = null;
if ($wild_morty_id !== "") {
    $wildPayload = get_wild_morty_payload($pdo, $room_id, $wild_morty_id);
    if ($wildPayload && !empty($wildPayload["morty_id"])) {
        $wildMortyId = (string)$wildPayload["morty_id"];
    }
}

$opponent = [
    "player_id"        => "317D0000-0000-0000-0000-000000000001",
    "username"         => "AWILDMORTY",
    "player_avatar_id" => "NOAVATAR",
    "owned_morties" => [[
        "owned_morty_id" => "00000000-0000-0000-0000-000000000002",
        "morty_id"       => $wildMortyId,   // dynamic from room:wild-morty-added
        "level" => 37, 
		"xp" => 50653, 
		"hp" => 104, 
		"variant" => "Normal", 
		"hp_stat" => 104,
    ]],
    "streak" => 0,
    "shiny_if_potion" => false,
    "_meta" => [
        "isPlayerInDB"     => false,
        "isControlledByAI" => true,
        "isRaidBoss"       => false,
    ],
    "active_owned_morty" => "00000000-0000-0000-0000-000000000002",
];

// load player
$stmt = $pdo->prepare("
  SELECT player_id, username, player_avatar_id,
         level, xp, streak, coins, coupons, permits,
         xp_lower, xp_upper, active_deck_id
  FROM users
  WHERE player_id = ?
  LIMIT 1
");
$stmt->execute([$player_id]);
$playerRow = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$playerRow) {
    http_response_code(404);
    echo json_encode(["success" => false, "error" => "Player not found"], JSON_UNESCAPED_SLASHES);
    exit;
}

// 4) load owned morties
$stmt = $pdo->prepare("
  SELECT owned_morty_id, morty_id, level, xp, hp, variant,
         hp_stat, xp_lower, xp_upper, is_locked, is_trading_locked
  FROM owned_morties
  WHERE player_id = ?
  ORDER BY created_at ASC
");
$stmt->execute([$player_id]);
$ownedMortiesRows = $stmt->fetchAll(PDO::FETCH_ASSOC);

// 5) attacks (group by owned_morty_id)
$attacksByOwnedMorty = [];
$ownedMortyIds = array_values(array_filter(array_map(fn($m) => $m["owned_morty_id"] ?? null, $ownedMortiesRows)));

if (!empty($ownedMortyIds)) {
    $ph = implode(",", array_fill(0, count($ownedMortyIds), "?"));
    $stmt = $pdo->prepare("
      SELECT owned_morty_id, attack_id, position, pp, pp_stat
      FROM owned_attacks
      WHERE owned_morty_id IN ($ph)
      ORDER BY owned_morty_id, position
    ");
    $stmt->execute($ownedMortyIds);
    foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $a) {
        $oid = (string)$a["owned_morty_id"];
        $attacksByOwnedMorty[$oid][] = [
            "attack_id" => (string)$a["attack_id"],
            "position"  => (int)$a["position"],
            "pp"        => (int)$a["pp"],
            "pp_stat"   => (int)$a["pp_stat"],
        ];
    }
}

// 6) owned items
$stmt = $pdo->prepare("SELECT item_id, quantity FROM owned_items WHERE player_id = ? ORDER BY item_id ASC");
$stmt->execute([$player_id]);
$ownedItems = array_map(fn($it) => [
    "item_id"  => (string)$it["item_id"],
    "quantity" => (int)$it["quantity"],
], $stmt->fetchAll(PDO::FETCH_ASSOC));

// 7) determine active_morty: first in active deck with hp>0
$activeOwnedMorty = "";

// 7a) read deck list by active_deck_id
$activeDeckId = (string)($playerRow["active_deck_id"] ?? "");
$deckMortyIds = [];

if ($activeDeckId !== "" && $activeDeckId !== "0") {
    $stmt = $pdo->prepare("SELECT owned_morty_ids FROM decks WHERE deck_id = ? LIMIT 1");
    $stmt->execute([$activeDeckId]);
    $deckRow = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($deckRow && isset($deckRow["owned_morty_ids"])) {
        $deckMortyIds = parse_id_list($deckRow["owned_morty_ids"]);
    }
}

// 7b) map hp for deck morties then pick first with hp>0 in deck order
if (!empty($deckMortyIds)) {
    $ph = implode(",", array_fill(0, count($deckMortyIds), "?"));
    $stmt = $pdo->prepare("
      SELECT owned_morty_id, hp
      FROM owned_morties
      WHERE owned_morty_id IN ($ph)
    ");
    $stmt->execute($deckMortyIds);

    $hpMap = [];
    foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $r) {
        $hpMap[(string)$r["owned_morty_id"]] = (int)$r["hp"];
    }

    foreach ($deckMortyIds as $oid) {
        if (($hpMap[$oid] ?? 0) > 0) {
            $activeOwnedMorty = (string)$oid;
            break;
        }
    }
}

// 7c) fallback: first owned morty with hp>0
if ($activeOwnedMorty === "") {
    foreach ($ownedMortiesRows as $m) {
        if ((int)($m["hp"] ?? 0) > 0) {
            $activeOwnedMorty = (string)$m["owned_morty_id"];
            break;
        }
    }
}

// 8) build owned_morties payload (with fixed boolean conversion)
$ownedMorties = array_map(function($m) use ($attacksByOwnedMorty) {
    $oid = (string)($m["owned_morty_id"] ?? "");
    return [
        "owned_morty_id" => $oid,
        "morty_id"       => (string)($m["morty_id"] ?? ""),
        "level"          => (int)($m["level"] ?? 1),
        "xp_lower"       => (int)($m["xp_lower"] ?? 0),
        "xp_upper"       => (int)($m["xp_upper"] ?? 0),
        "xp"             => (int)($m["xp"] ?? 0),
        "hp"             => (int)($m["hp"] ?? 0),
        "variant"        => (string)($m["variant"] ?? "Normal"),
        "hp_stat"        => (int)($m["hp_stat"] ?? 0),
        "is_locked"      => to_bool($m["is_locked"] ?? null),
        "is_trading_locked" => to_bool($m["is_trading_locked"] ?? null),
        "owned_attacks"  => $attacksByOwnedMorty[$oid] ?? [],
    ];
}, $ownedMortiesRows);

// 9) move_log default
$moveLog = [
    "cooldown" => new stdClass(),
    "count" => new stdClass(),
    "cooldown_next" => ["ITEM" => 1],
    "last_move_type" => new stdClass(),
];

// 10) player block
$player = [
    "player_id"        => (string)$playerRow["player_id"],
    "username"         => (string)$playerRow["username"],
    "player_avatar_id" => (string)$playerRow["player_avatar_id"],
    "level"            => (int)$playerRow["level"],
    "xp"               => (int)$playerRow["xp"],
    "streak"           => (int)$playerRow["streak"],
    "coins"            => (int)$playerRow["coins"],
    "coupons"          => (int)$playerRow["coupons"],
    "permits"          => (int)$playerRow["permits"],
    "owned_morties"    => $ownedMorties,
    "owned_items"      => $ownedItems,
    "tags"             => [],
    "xp_lower"         => (int)($playerRow["xp_lower"] ?? 0),
    "xp_upper"         => (int)($playerRow["xp_upper"] ?? 0),
    "_meta" => [
        "session_id"       => (string)$session_id,
        "isPlayerInDB"     => true,
        "isControlledByAI" => false,
        "isRaidBoss"       => false,
    ],
    "active_owned_morty" => $activeOwnedMorty,
    "move_log"           => $moveLog,
];

// 11) final payload
$payload = [
    "battle_id"   => (string)$battle["battle_id"],
    "battle_type" => (string)$battle["battle_type"],
    "player"      => $player,
    "opponent"    => $opponent,
    "meta"        => new stdClass(), // {}
];

$battle_wild_morty_payload = [
    "wild_morty_id"   => (string)$wild_morty_id,
    "state" => (string)"BATTLE"
];

$user_battle_payload = [
    "player_id"   => (string)$player_id,
    "state" => (string)"BATTLE"
];

// Publish into THIS player's current room stream (SSE will receive it)
publish_event($pdo, $room_id, "battle:start", $payload);
publish_event($pdo, $room_id, "room:wild-morty-state-changed", $battle_wild_morty_payload);
publish_event($pdo, $room_id, "room:user-state-changed", $user_battle_payload);

echo json_encode([
    "success" => true
], JSON_UNESCAPED_SLASHES);

