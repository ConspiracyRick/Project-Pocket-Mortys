<?php
header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Origin: *");

error_reporting(E_ALL);
ini_set('display_errors', 1);

require __DIR__ . "/../../../pocket_f4894h398r8h9w9er8he98he.php";
require_once __DIR__ . "/../../../lib/events.php";

// ========================
// INPUT
// ========================
$raw  = file_get_contents("php://input");
$body = json_decode($raw, true);

$session_id     = $body["session_id"] ?? "";
$battle_id      = $body["battle_id"] ?? "";
$type           = $body["type"] ?? "";
$owned_morty_id = $body["owned_morty_id"] ?? "";
$move_id        = $body["move_id"] ?? "";

if (!$session_id || !$battle_id || !$type) {
    http_response_code(400);
    echo json_encode(["success" => false]);
    exit;
}

// ========================
// PLAYER LOOKUP
// ========================
$stmt = $pdo->prepare("SELECT player_id, room_id FROM users WHERE session_id=? LIMIT 1");
$stmt->execute([$session_id]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(401);
    echo json_encode(["success" => false]);
    exit;
}

$player_id = $user["player_id"];
$room_id   = $user["room_id"];

// ========================
// GET BATTLE STATE
// ========================
$stmt = $pdo->prepare("SELECT * FROM battles WHERE battle_id=? LIMIT 1");
$stmt->execute([$battle_id]);
$battle = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$battle) {
    echo json_encode(["success" => false]);
    exit;
}

// ========================
// HELPERS
// ========================
function calculate_damage() {
    return rand(5, 10);
}

function get_ai_move() {
    $moves = ["AttackBatteringRam","AttackToxic","AttackVileSpew"];
    return $moves[array_rand($moves)];
}

// ========================
// TURN LOGIC
// ========================
$outcome = "CONTINUE";
$turn_datas = [];

$player_hp = (int)$battle["player_hp"];
$enemy_hp  = (int)$battle["opponent_hp"];

$ai_move = get_ai_move();

// ========================
// ITEM (CATCH)
// ========================
if ($type === "ITEM" && $move_id === "ItemMortyChip") {

    $success = rand(1,100) > 60;

    $turn_datas[] = [
        "type" => "ITEM",
        "attacker_player_id" => $player_id,
        "item_id" => "ItemMortyChip",
        "success" => $success
    ];

    if ($success) {
        $outcome = "CAUGHT";

        publish_event($pdo, $room_id, "battle:turn-result", [
            "battle_id" => $battle_id,
            "outcome" => $outcome,
            "turn_datas" => $turn_datas,
            "player_datas" => [
                "player" => [
                    "move_log" => [
                        "cooldown" => (object)[],
                        "count" => (object)[],
                        "cooldown_next" => ["ITEM" => 1],
                        "last_move_type" => "ITEM"
                    ],
                    "rewards" => [
                        ["type"=>"MORTY"]
                    ]
                ],
                "opponent" => (object)[]
            ]
        ], $player_id);

        echo json_encode(["success" => true]);
        exit;
    }
}

// ========================
// ATTACK TURN
// ========================
if ($type === "ATTACK") {

    $player_damage = calculate_damage();
    $ai_damage     = calculate_damage();

    $enemy_hp_after  = max($enemy_hp - $player_damage, 0);
    $player_hp_after = max($player_hp - $ai_damage, 0);

    // --------------------
    // PLAYER ATTACK FIRST (matches real flow better)
    // --------------------
    $turn_datas[] = [
        "type" => "ATTACK",
        "attacker_player_id" => $player_id,
        "defender_player_id" => $battle["opponent_id"],
        "attack_id" => $move_id,
        "element_modifier" => 1,
        "effect_datas" => [[
            "type" => "Hit",
            "is_accurate" => true,
            "to_self" => false,
            "continue_on_miss" => false,
            "is_critical" => false,
            "damage" => $player_damage,
            "defender_morty_datas" => [[
                "owned_morty_id" => $battle["opponent_active_morty"],
                "hp" => $enemy_hp_after
            ]]
        ]],
        "attacker_morty_datas" => [[
            "owned_morty_id" => $owned_morty_id,
            "owned_attacks" => [[
                "attack_id" => $move_id,
                "pp" => rand(1,5)
            ]]
        ]]
    ];

    // --------------------
    // AI ATTACK SECOND
    // --------------------
    $turn_datas[] = [
        "type" => "ATTACK",
        "attacker_player_id" => $battle["opponent_id"],
        "defender_player_id" => $player_id,
        "attack_id" => $ai_move,
        "element_modifier" => 1,
        "effect_datas" => [[
            "type" => "Hit",
            "is_accurate" => true,
            "to_self" => false,
            "is_critical" => false,
            "damage" => $ai_damage,
            "defender_morty_datas" => [[
                "owned_morty_id" => $owned_morty_id,
                "hp" => $player_hp_after
            ]]
        ]],
        "attacker_morty_datas" => [[
            "owned_morty_id" => $battle["opponent_active_morty"],
            "owned_attacks" => [[
                "attack_id" => $ai_move,
                "pp" => rand(1,5)
            ]]
        ]]
    ];

    // Update HP
    $player_hp = $player_hp_after;
    $enemy_hp  = $enemy_hp_after;

    if ($enemy_hp <= 0) {
        $outcome = "WIN";
    } elseif ($player_hp <= 0) {
        $outcome = "LOSE";
    }
}

// ========================
// SAVE STATE
// ========================
$stmt = $pdo->prepare("UPDATE battles SET player_hp=?, opponent_hp=? WHERE battle_id=?");
$stmt->execute([$player_hp, $enemy_hp, $battle_id]);

// ========================
// SEND STRICT SSE EVENT
// ========================
publish_event($pdo, $room_id, "battle:turn-result", [
    "battle_id" => $battle_id,
    "outcome" => $outcome,
    "turn_datas" => $turn_datas,
    "player_datas" => [
        "player" => [
            "move_log" => [
                "cooldown" => ["ATTACK" => 0],
                "count" => ["ATTACK" => count($turn_datas)],
                "cooldown_next" => ["ITEM" => 1],
                "last_move_type" => $type
            ]
        ],
        "opponent" => (object)[]
    ]
], $player_id);

// ========================
// NEXT TURN TIMER
// ========================
if ($outcome === "CONTINUE") {
    publish_event($pdo, $room_id, "battle:move-timer-started", [
        "battle_id" => $battle_id,
        "timeout" => 30
    ], $player_id);
}

// ========================
// IF LOSE
// ========================
if ($outcome === "LOSE") {
$wild_morty_id = $battle["opponent_active_morty"];
publish_event($pdo, $room_id, "room:wild-morty-state-changed", ["wild_morty_id"=>$wild_morty_id,"state"=>"WORLD"]);
publish_event($pdo, $room_id, "room:user-state-changed", ["player_id"=>$player_id,"state"=>"WORLD"]);
}

// ========================
// FINAL RESPONSE (IMPORTANT)
// ========================
echo json_encode(["success" => true]);