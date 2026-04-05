<?php
// sse-stream
// Streams session + room events via SSE.

error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

set_time_limit(0);
ignore_user_abort(true);

header('Content-Type: text/event-stream; charset=utf-8');
header('Cache-Control: no-cache');
header('Connection: keep-alive');
header('X-Accel-Buffering: no');

require __DIR__ . "/../pocket_f4894h398r8h9w9er8he98he.php";
require __DIR__ . "/../lib/auth.php";
require __DIR__ . "/../lib/events.php"; // provides sse_send()

// ---------------- SSE HELPERS ----------------

function sse_send_id(string $event, string $dataJson, ?int $id = null): void {
    //if ($id !== null) echo "id: {$id}\n"; // enable if you want EventSource resume support
    echo "event: {$event}\n";
    echo "data: {$dataJson}\n\n";
    @ob_flush(); @flush();
}

function base64url_decode($data) { return base64_decode(strtr($data, '-_', '+/')); }
function decode_jwt_payload($jwt) {
    $parts = explode('.', $jwt);
    if (count($parts) < 2) return null;
    return json_decode(base64url_decode($parts[1]), true);
}

// Only used as fallback if event_queue.player_id is NULL for private events
function payload_involves_player(string $payloadJson, string $player_id): bool {
    $d = json_decode($payloadJson, true);
    if (!is_array($d)) return false;

    $keys = [
        "player_id",
        "attacker_player_id",
        "defender_player_id",
        "challenger_player_id",
        "challenged_player_id",
        "owner_player_id",
    ];

    foreach ($keys as $k) {
        if (isset($d[$k]) && (string)$d[$k] === $player_id) return true;
    }

    if (isset($d["turn_datas"]) && is_array($d["turn_datas"])) {
        foreach ($d["turn_datas"] as $t) {
            if (!is_array($t)) continue;
            if (isset($t["attacker_player_id"]) && (string)$t["attacker_player_id"] === $player_id) return true;
            if (isset($t["defender_player_id"]) && (string)$t["defender_player_id"] === $player_id) return true;
        }
    }

    return false;
}

// Cursor stored in users table
function cursor_get(PDO $pdo, string $player_id): int {
    $q = $pdo->prepare("SELECT COALESCE(last_event_id, 0) FROM users WHERE player_id = ? LIMIT 1");
    $q->execute([$player_id]);
    return (int)$q->fetchColumn();
}
function cursor_set(PDO $pdo, string $player_id, int $last_id): void {
    $q = $pdo->prepare("UPDATE users SET last_event_id = ?, last_seen = NOW() WHERE player_id = ?");
    $q->execute([$last_id, $player_id]);
}
function room_max_event_id(PDO $pdo, string $room_id): int {
    $q = $pdo->prepare("SELECT COALESCE(MAX(id), 0) FROM event_queue WHERE room_id = ?");
    $q->execute([$room_id]);
    return (int)$q->fetchColumn();
}

/**
 * Normalize room:wild-morty-added payload so client always gets clickable WORLD entity.
 * Many DB rows are the "short shape" missing state/division/etc.
 */
function normalize_wild_morty_added(string $payloadJson): string {
    $d = json_decode($payloadJson, true);
    if (!is_array($d)) return $payloadJson;

    $wildId  = isset($d["wild_morty_id"]) ? (string)$d["wild_morty_id"] : "";
    $mortyId = isset($d["morty_id"]) ? (string)$d["morty_id"] : "";
    $place   = $d["placement"] ?? null;

    if ($wildId === "" || $mortyId === "" || !is_array($place) || count($place) !== 2) {
        return $payloadJson;
    }

    $placement = [(int)$place[0], (int)$place[1]];

    $state   = (isset($d["state"]) && $d["state"] !== "" && $d["state"] !== null) ? (string)$d["state"] : "WORLD";
    $variant = (isset($d["variant"]) && $d["variant"] !== "" && $d["variant"] !== null) ? (string)$d["variant"] : "Normal";

    $division = 1;
    if (isset($d["division"])) {
        $division = (int)$d["division"];
        if ($division <= 0) $division = 1;
    }

    $shinyIfPotion = false;
    if (isset($d["shiny_if_potion"])) {
        $shinyIfPotion = (bool)$d["shiny_if_potion"];
    }

    $created = isset($d["_created"]) ? (string)$d["_created"] : "";
    $updated = isset($d["_updated"]) ? (string)$d["_updated"] : "";

    if ($created === "" || $updated === "") {
        $now = gmdate("Y-m-d\\TH:i:s") . ".000Z";
        if ($created === "") $created = $now;
        if ($updated === "") $updated = $now;
    }

    $out = [
        "morty_id" => $mortyId,
        "placement" => $placement,
        "state" => $state,
        "division" => $division,
        "variant" => $variant,
        "shiny_if_potion" => $shinyIfPotion,
        "_created" => $created,
        "_updated" => $updated,
        "wild_morty_id" => $wildId,
    ];

    return json_encode($out, JSON_UNESCAPED_SLASHES);
}

// -------------------- AUTH --------------------

$token   = $_GET['token'] ?? null;
$profile = $token ? decode_jwt_payload($token) : null;

$session_id = (string)($profile['session_id'] ?? "");
if ($session_id === "") {
    http_response_code(400);
    sse_send_id("error", json_encode(["error" => "Missing session_id"], JSON_UNESCAPED_SLASHES));
    exit;
}

$stmt = $pdo->prepare("
    SELECT player_id, username, level, tags, room_id, player_avatar_id, state, COALESCE(last_event_id, 0) AS last_event_id
    FROM users
    WHERE session_id = ?
    LIMIT 1
");
$stmt->execute([$session_id]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(401);
    sse_send_id("error", json_encode(["error" => "Not authenticated"], JSON_UNESCAPED_SLASHES));
    exit;
}

$player_id = (string)$user["player_id"];

$tags = $user["tags"] ?? [];
if (is_string($tags)) {
    $decoded = json_decode($tags, true);
    $tags = is_array($decoded) ? $decoded : [];
} elseif (!is_array($tags)) {
    $tags = [];
}

$ping_url = (string)($profile['ping_url'] ?? "https://game.conspiracyrick.com/session/ping-dynamic");

// -------------------- SESSION START --------------------
// "server_instance" => "/ip-10-100-0-46/1/1143",
$session = [
    "player_id" => $player_id,
    "session_id" => $session_id,
    "username" => (string)$user["username"],
    "level" => (int)$user["level"],
    "tags" => $tags,
    "ping_interval" => 30,
    "ping_url" => $ping_url,
    "keep_alive" => 30,
    "server_instance" => "/ip-54-196-181-23/1/1143",
    "worlds" => [
        ["world_id"=>"1","player_level"=>["min"=>1,"max"=>50]],
        ["world_id"=>"2","player_level"=>["min"=>5,"max"=>50]],
        ["world_id"=>"3","player_level"=>["min"=>15,"max"=>50]],
        ["world_id"=>"4","player_level"=>["min"=>30,"max"=>50]],
        ["world_id"=>"5","player_level"=>["min"=>5,"max"=>50]],
        ["world_id"=>"6","player_level"=>["min"=>10,"max"=>50]],
        ["world_id"=>"7","player_level"=>["min"=>15,"max"=>50]],
    ],
    "owned_morty_limit" => 750
];

sse_send("session:start", json_encode($session, JSON_UNESCAPED_SLASHES));

// -------------------- WAIT FOR ROOM --------------------

$room_id = "";
$last_keepalive = time();

while (!connection_aborted()) {
    $st = $pdo->prepare("SELECT room_id FROM users WHERE player_id = ? LIMIT 1");
    $st->execute([$player_id]);
    $room_id = (string)$st->fetchColumn();

    if ($room_id !== "" && $room_id !== "0") break;

    if ((time() - $last_keepalive) >= 25) {
        sse_send("session:keep-alive", "0");
        $last_keepalive = time();
    }
    usleep(250000);
}

if ($room_id === "" || $room_id === "0") exit;

// -------------------- RESUME OR FRESH CONNECT? --------------------

$client_last_event_id = null;
if (!empty($_SERVER['HTTP_LAST_EVENT_ID']) && ctype_digit($_SERVER['HTTP_LAST_EVENT_ID'])) {
    $client_last_event_id = (int)$_SERVER['HTTP_LAST_EVENT_ID'];
}
if ($client_last_event_id === null && isset($_GET['since']) && ctype_digit((string)$_GET['since'])) {
    $client_last_event_id = (int)$_GET['since'];
}

$fresh_connect = ($client_last_event_id === null);

// -------------------- INITIAL SNAPSHOT (ONLY ON FRESH CONNECT) --------------------

if ($fresh_connect) {
    // other users in room (no self)
    $u = $pdo->prepare("
        SELECT player_id, username, player_avatar_id, level, state
        FROM users
        WHERE room_id = ?
          AND last_seen >= (NOW() - INTERVAL 5 MINUTE)
    ");
    $u->execute([$room_id]);

    while ($row = $u->fetch(PDO::FETCH_ASSOC)) {
        if ((string)$row["player_id"] === $player_id) continue;

        sse_send("room:user-added", json_encode([
            "player_id" => (string)$row["player_id"],
            "username" => (string)$row["username"],
            "player_avatar_id" => (string)$row["player_avatar_id"],
            "level" => (int)$row["level"],
            "state" => (string)($row["state"] ?: "WORLD"),
        ], JSON_UNESCAPED_SLASHES));
    }

    // pickups alive only
    $p = $pdo->prepare("
        SELECT id, payload_json
        FROM event_queue
        WHERE room_id = ?
          AND event_name = 'room:pickup-added'
          AND pickup_id_collected_by_player_id IS NULL
        ORDER BY id ASC
    ");
    $p->execute([$room_id]);
    while ($row = $p->fetch(PDO::FETCH_ASSOC)) {
        sse_send_id("room:pickup-added", (string)$row["payload_json"], (int)$row["id"]);
    }

    // wild mortys - normalize payload so they become interactable
    $w = $pdo->prepare("
        SELECT id, payload_json
        FROM event_queue
        WHERE room_id = ?
          AND event_name = 'room:wild-morty-added'
        ORDER BY id ASC
    ");
    $w->execute([$room_id]);
    while ($row = $w->fetch(PDO::FETCH_ASSOC)) {
        $payload = normalize_wild_morty_added((string)$row["payload_json"]);
        sse_send_id("room:wild-morty-added", $payload, (int)$row["id"]);
    }

    // bots
    $b = $pdo->prepare("
        SELECT id, payload_json
        FROM event_queue
        WHERE room_id = ?
          AND event_name = 'room:bot-added'
        ORDER BY id ASC
    ");
    $b->execute([$room_id]);
    while ($row = $b->fetch(PDO::FETCH_ASSOC)) {
        sse_send_id("room:bot-added", (string)$row["payload_json"], (int)$row["id"]);
    }

    // After snapshot seed, set cursor to current max so we don't replay snapshot rows
    $last_id = room_max_event_id($pdo, $room_id);
    cursor_set($pdo, $player_id, $last_id);
} else {
    $last_id = (int)$client_last_event_id;
    cursor_set($pdo, $player_id, $last_id);
}

// -------------------- MAIN STREAM LOOP --------------------

$keepalive_interval_sec = 30;
$last_keepalive = time();

// These events should only be delivered to the triggering / involved player.
// (We primarily use event_queue.player_id to decide.)
$privateEvents = ["battle:start","battle:move-timer-started","battle:turn-result"];

while (!connection_aborted()) {

    // touch presence
    $pdo->prepare("UPDATE users SET last_seen = NOW() WHERE player_id = ?")
        ->execute([$player_id]);

    // IMPORTANT: also fetch event_queue.player_id
    $stmt = $pdo->prepare("
        SELECT id, event_name, payload_json, player_id AS target_player_id
        FROM event_queue
        WHERE room_id = ?
          AND id > ?
        ORDER BY id ASC
        LIMIT 200
    ");
    $stmt->execute([$room_id, $last_id]);

    $sent = false;

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $eventName = (string)$row["event_name"];
        $payload   = (string)$row["payload_json"];
        $eid       = (int)$row["id"];
        $targetPid = (string)($row["target_player_id"] ?? "");

        // ---- PRIVATE EVENT FILTERING ----
        if (in_array($eventName, $privateEvents, true)) {
            // Strong rule: if DB has a target player, ONLY send to that player.
            if ($targetPid !== "" && $targetPid !== $player_id) {
                $last_id = $eid;
                continue;
            }

            // Fallback: if DB target is empty, try to infer from payload
            if ($targetPid === "" && !payload_involves_player($payload, $player_id)) {
                $last_id = $eid;
                continue;
            }
        }

        // Normalize wild morty payload shape live too
        if ($eventName === "room:wild-morty-added") {
            $payload = normalize_wild_morty_added($payload);
        }

        sse_send_id($eventName, $payload, $eid);
        $last_id = $eid;
        $sent = true;
    }

    cursor_set($pdo, $player_id, $last_id);

    if (!$sent && (time() - $last_keepalive) >= $keepalive_interval_sec) {
        sse_send("session:keep-alive", "0");
        $last_keepalive = time();
    }

    usleep(300000);
}
