<?php
// player-details
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

header("Content-Type: application/json; charset=utf-8");
header("X-Powered-By: Express");
header("Access-Control-Allow-Origin: *");
header("Vary: Accept-Encoding");

require '../../pocket_f4894h398r8h9w9er8he98he.php';

function toBool($v) {
    return filter_var($v, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE) ?? false;
}

function toNull($v) {
    return ($v === null || $v === '' || strtolower($v) === 'null') ? null : $v;
}


$input = file_get_contents('php://input');
$data = json_decode($input, true);

$session_id = $data['session_id'];

if (empty($session_id)) {
    die("Not authenticated");
}

$stmt = $pdo->prepare("SELECT * FROM users WHERE session_id = ?");
$stmt->execute([$session_id]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    die("Not authenticated");
}

$player_id = $user['player_id'];
$player_avatar_id = $user['player_avatar_id'];

$stmt = $pdo->prepare("
    SELECT 
        m.owned_morty_id,
        m.morty_id,
        m.level,
        m.xp,
        m.hp,
        m.hp_stat,
        m.attack_stat,
        m.defence_stat,
        m.variant,
        m.speed_stat,
        m.is_locked,
        m.is_trading_locked,
        m.fight_pit_id,
        m.evolution_points,
        m.xp_lower,
        m.xp_upper,

        a.attack_id,
        a.position,
        a.pp,
        a.pp_stat

    FROM owned_morties m
    LEFT JOIN owned_attacks a 
        ON m.owned_morty_id = a.owned_morty_id

    WHERE m.player_id = ?
    ORDER BY m.owned_morty_id, a.position ASC
");

$stmt->execute([$player_id]);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

$owned_morties = [];

foreach ($rows as $row) {
    $id = $row['owned_morty_id'];

    if (!isset($owned_morties[$id])) {
        $owned_morties[$id] = [
            "owned_morty_id" => $row['owned_morty_id'],
            "morty_id" => $row['morty_id'],
            "level" => (int)$row['level'],
            "xp" => (int)$row['xp'],
            "hp" => (int)$row['hp'],
            "hp_stat" => (int)$row['hp_stat'],
            "attack_stat" => (int)$row['attack_stat'],
            "defence_stat" => (int)$row['defence_stat'],
            "variant" => $row['variant'],
            "speed_stat" => (int)$row['speed_stat'],
            "is_locked" => toBool($row['is_locked']),
            "is_trading_locked" => toBool($row['is_trading_locked']),
            "fight_pit_id" => toNull($row['fight_pit_id']),
            "evolution_points" => (int)$row['evolution_points'],
            "xp_lower" => (int)$row['xp_lower'],
            "xp_upper" => (int)$row['xp_upper'],
            "owned_attacks" => []
        ];
    }

    // Only add attack if one exists
    if ($row['attack_id']) {
        $owned_morties[$id]['owned_attacks'][] = [
            "attack_id" => $row['attack_id'],
            "position" => (int)$row['position'],
            "pp" => (int)$row['pp'],
            "pp_stat" => (int)$row['pp_stat']
        ];
    }
}

$owned_morties = array_values($owned_morties);




$stmt = $pdo->prepare("SELECT deck_id, owned_morty_ids FROM decks WHERE player_id = ?");
$stmt->execute([$player_id]);
$decks_raw = $stmt->fetchAll(PDO::FETCH_ASSOC);

$decks = [];
foreach ($decks_raw as $deck) {
    $decks[] = [
        'deck_id' => (int)$deck['deck_id'],
        'owned_morty_ids' => json_decode($deck['owned_morty_ids'], true)
    ];
}

$stmt = $pdo->prepare("SELECT item_id, quantity FROM owned_items WHERE player_id = ?");
$stmt->execute([$player_id]);
$owned_items = $stmt->fetchAll(PDO::FETCH_ASSOC);

$stmt = $pdo->prepare("SELECT player_avatar_id FROM owned_avatars WHERE player_id = ?");
$stmt->execute([$player_id]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

$avatarString = trim($row['player_avatar_id'], '[]"'); // remove brackets/quotes if present
$avatarArray = array_map('trim', explode(',', $avatarString));

$owned_avatars = array_map(function($avatar) {
    return ["player_avatar_id" => $avatar];
}, $avatarArray);

$stmt = $pdo->prepare("SELECT morty_id, caught FROM mortydex WHERE player_id = ?");
$stmt->execute([$player_id]);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
$mortydex = [];
foreach ($rows as $row) {
    $mortydex[] = [
        "morty_id" => $row['morty_id'],
        "caught"   => filter_var($row['caught'], FILTER_VALIDATE_BOOLEAN)
    ];
}


$responseArray = [
    "player_id" => $user['player_id'] ?? "",
    "username" => $user['username'] ?? "",
    "player_avatar_id" => $player_avatar_id ?? "AvatarRickDefault",

    "level" => (int)($user['level'] ?? 1),
    "xp" => (int)($user['xp'] ?? 0),
    "streak" => (int)($user['streak'] ?? 0),

    "coins" => (int)($user['coins'] ?? 0),
    "coupons" => (int)($user['coupons'] ?? 0),
    "permits" => (int)($user['permits'] ?? 0),

    "challenge_reward" => false,

    "owned_morties" => array_values($owned_morties ?? []),

    "active_deck_id" => (int)($user['active_deck_id'] ?? 0),
    "decks_owned" => (int)($user['decks_owned'] ?? 0),
    "decks" => array_values($decks ?? []),

    "owned_items" => array_values($owned_items ?? []),
    "owned_avatars" => array_values($owned_avatars ?? []),
    "mortydex" => array_values($mortydex ?? []),

    "tags" => [],
    "play_shiny_potion" => null,

    "xp_lower" => (int)($user['xp_lower'] ?? 0),
    "xp_upper" => (int)($user['xp_upper'] ?? 0),
];
echo json_encode($responseArray, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
exit;
