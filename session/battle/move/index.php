<?php
// move
header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Origin: *");

error_reporting(E_ALL);
ini_set('display_errors', 1);

require __DIR__ . "/../../../pocket_f4894h398r8h9w9er8he98he.php";
require_once __DIR__ . "/../../../lib/events.php";

// Read body
$raw  = file_get_contents("php://input");
$body = json_decode($raw, true);
if (!is_array($body)) $body = [];

// ---------- helpers ----------
function fail_json(int $code, string $msg, array $extra = []) {
    http_response_code($code);
    echo json_encode(array_merge(["success" => false, "error" => $msg], $extra), JSON_UNESCAPED_SLASHES);
    exit;
}

// ---------- required fields ----------
$session_id = (string)($body["session_id"] ?? "");
if ($session_id === "") fail_json(400, "Missing session_id");

$battle_id = (string)($body["battle_id"] ?? "");
if ($battle_id === "") fail_json(400, "Missing battle_id");

$owned_morty_id = (string)($body["owned_morty_id"] ?? "");
if ($owned_morty_id === "") fail_json(400, "Missing owned_morty_id");

// ---------- move_id is nullable ----------
$type = $body["type"] ?? null;
$move_id = $body["move_id"] ?? null;

if ($move_id === "") $move_id = null;

if ($move_id !== null && !is_string($move_id)) {
    fail_json(400, "Invalid move_id");
}
if ($move_id !== null) {
    $move_id = trim($move_id);
    if ($move_id === "") $move_id = null;
}

// normalize outcome (you were mixing 'type' with 'outcome')
if ($type === "ITEM" || $type === "RUN") {
    $outcome = $type;
} else {
    $outcome = "CONTINUE";
}

// ---------- auth: get player + room ----------
$stmt = $pdo->prepare("
  SELECT player_id, room_id
  FROM users
  WHERE session_id = ?
  LIMIT 1
");
$stmt->execute([$session_id]);
$u = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$u) fail_json(401, "Not authenticated");

$player_id = (string)$u["player_id"];
$room_id   = (string)($u["room_id"] ?? "");

if ($room_id === "" || $room_id === "0") {
    fail_json(409, "Player is not in a room");
}

// ---------- Verify room exists ----------
$chk = $pdo->prepare("SELECT 1 FROM room_ids WHERE room_id = ? LIMIT 1");
$chk->execute([$room_id]);
if (!$chk->fetchColumn()) {
    fail_json(409, "Room does not exist", ["room_id" => $room_id]);
}

// ---------- verify owned_morty_id belongs to this player + get its hp ----------
$stmt = $pdo->prepare("
  SELECT owned_morty_id, hp
  FROM owned_morties
  WHERE owned_morty_id = ?
    AND player_id = ?
  LIMIT 1
");
$stmt->execute([$owned_morty_id, $player_id]);
$om = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$om) {
    fail_json(403, "owned_morty_id does not belong to player", [
        "owned_morty_id" => $owned_morty_id,
        "player_id" => $player_id
    ]);
}

$owned_hp = (int)($om["hp"] ?? 0);
if ($owned_hp <= 0) {
    fail_json(409, "Morty has no HP", ["owned_morty_id" => $owned_morty_id, "hp" => $owned_hp]);
}

// ---------- validate move against owned_attacks for THIS owned_morty_id ----------
$pp_after = null;
$pp_stat  = null;

if ($move_id !== null) {
    // If it’s an ATTACK, confirm it exists for this morty AND PP>0
    // (If you later allow ITEM moves here, branch on $type)
    $stmt = $pdo->prepare("
      SELECT pp, pp_stat
      FROM owned_attacks
      WHERE owned_morty_id = ?
        AND attack_id = ?
      LIMIT 1
    ");
    $stmt->execute([$owned_morty_id, $move_id]);
    $atkRow = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$atkRow) {
        fail_json(400, "Attack does not belong to this morty", [
            "attack_id" => $move_id,
            "owned_morty_id" => $owned_morty_id
        ]);
    }

    $pp = (int)($atkRow["pp"] ?? 0);
    $pp_stat = (int)($atkRow["pp_stat"] ?? 0);

    if ($pp <= 0) {
        fail_json(409, "No PP", [
            "attack_id" => $move_id,
            "owned_morty_id" => $owned_morty_id,
            "pp" => $pp
        ]);
    }

    // Optional: compute what PP will be after this move (don’t write yet unless you want persistence)
    $pp_after = $pp - 1;
}

/*
data: [{"type":"ATTACK","attacker_player_id":"dfd1bb4f-5a40-4841-ac32-d4ae2ba72b1f","defender_player_id":"317D0000-0000-0000-0000-000000000001","attack_id":"AttackTroll","element_modifier":1.75,"effect_datas":[{"type":"Stat","is_accurate":true,"to_self":false,"stat":"Attack","amount":-2},{"type":"Stat","is_accurate":true,"to_self":false,"stat":"Defence","amount":-2},{"type":"Stat","is_accurate":false,"to_self":false,"stat":"Speed","amount":-2}],"attacker_morty_datas":[{"owned_morty_id":"25c17be8-ff95-11f0-ac5c-fbcdf11f92d8","owned_attacks":[{"attack_id":"AttackTroll","pp":3}]}]},{"type":"ATTACK","attacker_player_id":"317D0000-0000-0000-0000-000000000001","defender_player_id":"dfd1bb4f-5a40-4841-ac32-d4ae2ba72b1f","attack_id":"AttackMutate","element_modifier":1,"effect_datas":[{"type":"Hit","is_accurate":true,"to_self":false,"is_critical":false,"damage":19,"defender_morty_datas":[{"owned_morty_id":"25c17be8-ff95-11f0-ac5c-fbcdf11f92d8","hp":20}]}],"attacker_morty_datas":[{"owned_morty_id":"00000000-0000-0000-0000-000000000002","owned_attacks":[{"attack_id":"AttackMutate","pp":7}]}]}],"player_datas":{"player":{"move_log":{"cooldown":{"ATTACK":0},"count":{"ATTACK":1},"cooldown_next":{"ITEM":1},"last_move_type":"ATTACK"}},"opponent":{}}
*/


// ---------- Build battle:turn-result payload ----------
$battle_payload = [
    "battle_id" => $battle_id,
    "outcome"   => "RUN",

    "turn_datas" => [
        [
            "type" => "ATTACK",
            "attacker_player_id" => $player_id,
            "defender_player_id" => "317D0000-0000-0000-0000-000000000001",
            "attack_id" => $move_id, // can be null
            "element_modifier" => 1,

            "effect_datas" => [
                [
                    "type" => "Stat",
                    "is_accurate" => true,
                    "to_self" => true,
                    "stat" => "Attack",
                    "amount" => 1,
                ],
                [
                    "type" => "Stat",
                    "is_accurate" => true,
                    "to_self" => true,
                    "stat" => "Defence",
                    "amount" => 3,
                ],
            ],

            "attacker_morty_datas" => [
                [
                    "owned_morty_id" => $owned_morty_id,
                    "owned_attacks" => [
                        [
                            "attack_id" => $move_id,
                            // if move_id is null, this will be null too; that’s okay if client allows it
                            "pp" => ($pp_after !== null ? (int)$pp_after : null),
                        ],
                    ],
                ],
            ],
        ],

        // opponent turn placeholder (unchanged)
        [
            "type" => "ATTACK",
            "attacker_player_id" => "317D0000-0000-0000-0000-000000000001",
            "defender_player_id" => $player_id,
            "attack_id" => "AttackDoze",
            "element_modifier" => 1,

            "effect_datas" => [
                [
                    "type" => "Stat",
                    "is_accurate" => true,
                    "to_self" => false,
                    "stat" => "Accuracy",
                    "amount" => -3,
                ],
            ],

            "attacker_morty_datas" => [
                [
                    "owned_morty_id" => "00000000-0000-0000-0000-000000000002",
                    "owned_attacks" => [
                        [
                            "attack_id" => "AttackDoze",
                            "pp" => 9,
                        ],
                    ],
                ],
            ],
        ],
    ],

    "player_datas" => [
        "player" => [
            "move_log" => [
                "cooldown" => [
                    "ATTACK" => 0,
                ],
                "count" => [
                    "ATTACK" => 1,
                ],
                "cooldown_next" => [
                    "ITEM" => 1,
                ],
                "last_move_type" => "ATTACK",
            ],
        ],
        "opponent" => new stdClass(), // {}
    ],
];

// ---------- 6) Publish event ----------
publish_event($pdo, $room_id, "battle:turn-result", $battle_payload, (string)$player_id);

echo json_encode(["success" => true], JSON_UNESCAPED_SLASHES);
