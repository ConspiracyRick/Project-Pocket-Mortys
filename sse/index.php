<?php
// sse stream

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
require __DIR__ . "/../lib/events.php";

// ---- local SSE sender that supports id: ----
function sse_send_id(string $event, string $dataJson, ?int $id = null): void {
    //if ($id !== null) echo "id: {$id}\n";
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
function payload_player_id($json) {
    $d = json_decode($json, true);
    return (is_array($d) && isset($d["player_id"])) ? (string)$d["player_id"] : null;
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

// --- auth ---
$token = $_GET['token'] ?? null;
$profile = $token ? decode_jwt_payload($token) : null;

$session_id = $profile['session_id'] ?? "";
if ($session_id === "") {
    http_response_code(400);
    sse_send_id("error", json_encode(["error" => "Missing session_id"], JSON_UNESCAPED_SLASHES));
    exit;
}

// Pull player_id + user fields directly from users table (what you wanted)
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

$ping_url = $profile['ping_url'] ?? "https://game.conspiracyrick.com/session/ping-dynamic";

$session = [
    "player_id" => $player_id,
    "session_id" => $session_id,
    "username" => (string)$user["username"],
    "level" => (int)$user["level"],
    "tags" => $tags,
    "ping_interval" => 30,
    "ping_url" => $ping_url,
    "keep_alive" => 30,
    "server_instance" => "/ip-10-100-0-46/1/1143",
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

// Use sse_send from your events.php for non-id events
sse_send("session:start", json_encode($session, JSON_UNESCAPED_SLASHES));

// wait for room (using users.room_id like you asked)
$room_id = null;
$last_keepalive = time();

while (!connection_aborted()) {
    $stmt = $pdo->prepare("SELECT room_id FROM users WHERE player_id = ? LIMIT 1");
    $stmt->execute([$player_id]);
    $room_id = (string)$stmt->fetchColumn();

    if ($room_id !== "" && $room_id !== "0") break;

    $now = time();
    if (($now - $last_keepalive) >= 25) {
        sse_send("session:keep-alive", "0");
        $last_keepalive = $now;
    }
    usleep(250000);
}
if (!$room_id) exit;

// initial snapshot: other users (no self)
$u = $pdo->prepare("SELECT player_id, username, player_avatar_id, level, state FROM users WHERE room_id = ?");
$u->execute([$room_id]);
foreach ($u->fetchAll(PDO::FETCH_ASSOC) as $row) {
    if ((string)$row["player_id"] === $player_id) continue;
    sse_send("room:user-added", json_encode([
        "player_id" => (string)$row["player_id"],
        "username" => (string)$row["username"],
        "player_avatar_id" => (string)$row["player_avatar_id"],
        "level" => (int)$row["level"],
        "state" => (string)$row["state"],
    ], JSON_UNESCAPED_SLASHES));
}

// initial snapshot: other users user-modified (no self)
$a = $pdo->prepare("SELECT player_id, username, player_avatar_id, level, state FROM users WHERE room_id = ?");
$a->execute([$room_id]);
foreach ($a->fetchAll(PDO::FETCH_ASSOC) as $row) {
    if ((string)$row["player_id"] === $player_id) continue;
    sse_send("room:user-modified", json_encode([
        "player_id" => (string)$row["player_id"],
        "username" => (string)$row["username"],
        "player_avatar_id" => (string)$row["player_avatar_id"],
        "level" => (int)$row["level"],
        "state" => (string)$row["state"],
    ], JSON_UNESCAPED_SLASHES));
}

// choose last_id
$last_id = 0;

if (!empty($_SERVER['HTTP_LAST_EVENT_ID']) && ctype_digit($_SERVER['HTTP_LAST_EVENT_ID'])) {
    $last_id = (int)$_SERVER['HTTP_LAST_EVENT_ID'];
} else {
    // Use users.last_event_id (you removed room_stream_cursor)
    $last_id = cursor_get($pdo, $player_id);
    if ($last_id <= 0) {
        // emergency fallback: start from current max so they don't get spammed
        $max = $pdo->prepare("SELECT COALESCE(MAX(id), 0) FROM event_queue WHERE room_id = ?");
        $max->execute([$room_id]);
        $last_id = (int)$max->fetchColumn();
        cursor_set($pdo, $player_id, $last_id);
    }
}

$keepalive_interval_sec = 30;
$last_keepalive = time();

while (!connection_aborted()) {

    // Update last_seen (and keep last_event_id current periodically via cursor_set)
    $pdo->prepare("UPDATE users SET last_seen = NOW() WHERE player_id = ?")
        ->execute([$player_id]);

    $stmt = $pdo->prepare("
      SELECT id, event_name, payload_json
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

        // filter self events
        if (
            in_array($eventName, [
                "room:user-added",
                "room:user-modified",
                "room:user-state-changed"
            ], true)
            && payload_player_id($payload) === $player_id
        ) {
            $last_id = $eid;
            continue;
        }

        // send with id: so EventSource can resume correctly
        sse_send_id($eventName, $payload, $eid);

        $last_id = $eid;
        $sent = true;
    }

    // Persist cursor in users table
    cursor_set($pdo, $player_id, $last_id);

    $now = time();
    if (!$sent && ($now - $last_keepalive) >= $keepalive_interval_sec) {
        sse_send("session:keep-alive", "0");
        $last_keepalive = $now;
    }

    usleep(300000);
}
