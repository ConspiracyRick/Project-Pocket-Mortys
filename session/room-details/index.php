<?php
header("Content-Type: application/json; charset=utf-8");
header("X-Powered-By: Express");
header("Access-Control-Allow-Origin: *");
header("Vary: Accept-Encoding");

error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once "../../pocket_f4894h398r8h9w9er8he98he.php";
require_once __DIR__ . "/../../lib/events.php";
require_once __DIR__ . "/../../lib/room_entities.php";

$input = json_decode(file_get_contents("php://input"), true);

if (!isset($input["session_id"])) {
    echo json_encode(["error" => "Missing session_id"]);
    exit;
}

$session_id = $input["session_id"];

/**
 * 1. Get requesting user
 */
$stmt = $pdo->prepare("
    SELECT player_id, room_id
    FROM users
    WHERE session_id = ?
    LIMIT 1
");
$stmt->execute([$session_id]);
$self = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$self) {
    echo json_encode(["error" => "Invalid session"]);
    exit;
}

$room_id = $self["room_id"];

/**
 * 2. Room metadata
 */
$stmt = $pdo->prepare("SELECT * FROM room_ids WHERE room_id = ? LIMIT 1");
$stmt->execute([$room_id]);
$room = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$room) {
    echo json_encode(["error" => "Room not found"]);
    exit;
}

/**
 * 3. Get latest player states from event_queue
 */
$stmt = $pdo->prepare("
    SELECT eq.player_id, eq.payload_json
    FROM event_queue eq
    INNER JOIN (
        SELECT player_id, MAX(id) AS max_id
        FROM event_queue
        WHERE room_id = ?
        AND player_id IS NOT NULL
        GROUP BY player_id
    ) latest
    ON eq.player_id = latest.player_id AND eq.id = latest.max_id
");
$stmt->execute([$room_id]);
$events = $stmt->fetchAll(PDO::FETCH_ASSOC);

/**
 * 4. Build USERS (REAL PLAYERS ONLY)
 */
$users = [];

foreach ($events as $event) {
    $player_id = $event["player_id"];
    if (!$player_id) continue;

    $payload = json_decode($event["payload_json"], true);

    /**
     * Get user info from DB (TRUST DB, NOT EVENT)
     */
    $stmtUser = $pdo->prepare("
        SELECT username, player_avatar_id, level, active_deck_id
        FROM users
        WHERE player_id = ?
        LIMIT 1
    ");
    $stmtUser->execute([$player_id]);
    $dbUser = $stmtUser->fetch(PDO::FETCH_ASSOC);

    if (!$dbUser) continue;

    /**
     * Get ACTIVE DECK morty IDs
     */
    $stmtDeck = $pdo->prepare("
        SELECT owned_morty_ids
        FROM decks
        WHERE player_id = ?
        AND deck_id = ?
        LIMIT 1
    ");
    $stmtDeck->execute([$player_id, $dbUser["active_deck_id"]]);
    $deck = $stmtDeck->fetch(PDO::FETCH_ASSOC);

    $deck_morty_ids = [];

    if ($deck && !empty($deck["owned_morty_ids"])) {
        // stored as JSON or comma string — handle both
        $decoded = json_decode($deck["owned_morty_ids"], true);

        if (is_array($decoded)) {
            $deck_morty_ids = $decoded;
        } else {
            $deck_morty_ids = explode(",", $deck["owned_morty_ids"]);
        }
    }

    /**
     * Fetch ONLY those morties
     */
    $formatted_morties = [];

    if (!empty($deck_morty_ids)) {
        $placeholders = implode(',', array_fill(0, count($deck_morty_ids), '?'));

        $params = $deck_morty_ids;
        array_unshift($params, $player_id);

        $stmtMorties = $pdo->prepare("
            SELECT owned_morty_id, morty_id, hp, variant, is_locked, is_trading_locked, fight_pit_id
            FROM owned_morties
            WHERE player_id = ?
            AND owned_morty_id IN ($placeholders)
        ");
        $stmtMorties->execute($params);

        foreach ($stmtMorties->fetchAll(PDO::FETCH_ASSOC) as $m) {
            $formatted_morties[] = [
                "owned_morty_id" => $m["owned_morty_id"],
                "morty_id" => $m["morty_id"],
                "hp" => (int)$m["hp"],
                "variant" => $m["variant"],
                "is_locked" => (bool)$m["is_locked"],
                "is_trading_locked" => (bool)$m["is_trading_locked"],
                "fight_pit_id" => $m["fight_pit_id"]
            ];
        }
    }

    $users[] = [
        "player_id" => $player_id,
        "username" => $dbUser["username"],
        "player_avatar_id" => $dbUser["player_avatar_id"],
        "level" => (int)$dbUser["level"],
        "owned_morties" => $formatted_morties,
        "state" => $payload["state"] ?? "WORLD"
    ];
}

/**
 * 5. FULL ROOM SNAPSHOT (CORRECT SOURCE OF TRUTH)
 */
$entities = build_room_snapshot_from_events($pdo, $room_id);

$pickups = $entities["pickups"] ?? [];
$wild_morties = $entities["wild_morties"] ?? [];
$bots = $entities["bots"] ?? [];

/**
 * 8. Final response
 */
echo json_encode([
    "room_id" => $room["room_id"],
    "room_udp_host" => $room["room_udp_host"],
    "room_udp_port" => $room["room_udp_port"],
    "world_id" => $room["world_id"],
    "zone_id" => $room["zone_id"],

    "users" => $users,
    "pickups" => $pickups,
    "wild_morties" => $wild_morties,
    "bots" => $bots,

    "baseline_event_id" => (int)$room["id"]
], JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);