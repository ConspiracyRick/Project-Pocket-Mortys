<?php
// room spawner
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json; charset=utf-8");

require __DIR__ . "/../pocket_f4894h398r8h9w9er8he98he.php"; // $pdo
require __DIR__ . "/events.php"; // publish_event()

// ---------------- CONFIG ----------------
const TARGET_PICKUPS_PER_ROOM   = 3;
const TARGET_WILD_MORTIES_ROOM  = 4;
const TARGET_BOTS_PER_ROOM      = 5;

const MAX_SCAN_EVENTS = 3000; // how many events to replay per room to rebuild "active" state

// ---------------- SPAWN POINTS ----------------
// Pickups use the item points you had working
const PICKUP_POINTS = [
  [25,87],
  [34,83],
  [42,64],
  [48,87],
  [57,48],
  [65,79],
];

// Wild morties + bots
const MOB_POINTS = [
  [5,  82],
  [12, 84],
  [15, 4],
  [24, 57],
  [24, 76],
  [32, 76],
  [36, 59],
  [37, 76],
  [42, 75],
  [47, 68],
  [49, 84],
  [55, 79],
];

// ---------------- POOLS ----------------
function wildMortyPool(): array {
  return [
    ["morty_id" => "MortyPrisoner",     "variant" => "Normal"],
    ["morty_id" => "MortyCrying",       "variant" => "Normal"],
    ["morty_id" => "MortyCrow",         "variant" => "Normal"],
    ["morty_id" => "MortyTeaCup",       "variant" => "Normal"],
    ["morty_id" => "MortySoldadoLoco",  "variant" => "Normal"],
    ["morty_id" => "MortyFelon",        "variant" => "Normal"],
    ["morty_id" => "MortyMulti",        "variant" => "Normal"],
    ["morty_id" => "MortyExoPrime",     "variant" => "Normal"],
    ["morty_id" => "MortyRobotChicken", "variant" => "Normal"],
  ];
}

function botNamePool(): array {
  return ["Ataraxy","Carpedge","ChloeTombola","Loxodromy","Barbirdation","EasementJustice"];
}

function botAvatarPool(): array {
  return ["AvatarTeacherRick","AvatarMoochJerry","AvatarBeth","AvatarRickSuperFan","AvatarRickDefault"];
}

function botMortyPool(): array {
  return ["MortyPoorHouse","MortyGunk","MortySoldier","MortyTyrantLizard","MortyAndroid"];
}

// Loot table for pickups
function lootTableByRarity(): array {
  return [
    5   => ["ItemMegaSeedSpeed","ItemTinCan","ItemCircuitBoard","ItemCable","ItemPlutonicRock","ItemBacteriaCell"],
    75  => ["ItemPoisonCure","ItemCable","ItemCircuitBoard"],
    100 => ["ItemSerum","ItemDarkEnergyBall","ItemCircuitBoard","ItemPlutonicRock"],
  ];
}

// ---------------- HELPERS ----------------
function uuidv4(): string {
  $data = random_bytes(16);
  $data[6] = chr((ord($data[6]) & 0x0f) | 0x40);
  $data[8] = chr((ord($data[8]) & 0x3f) | 0x80);
  return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}
function randInt(int $min, int $max): int { return random_int($min, $max); }

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

function pickRarity(): int {
  return (int) weighted_pick([
    ["value" => 5,   "weight" => 55],
    ["value" => 75,  "weight" => 30],
    ["value" => 100, "weight" => 15],
  ]);
}

function pickItemId(int $rarity, array $excludeItemIds = []): string {
  $table = lootTableByRarity();
  $pool = $table[$rarity] ?? ["ItemCircuitBoard"];

  if ($excludeItemIds) {
    $filtered = array_values(array_diff($pool, $excludeItemIds));
    if ($filtered) $pool = $filtered;
  }
  return $pool[array_rand($pool)];
}

// Rebuild active state by replaying events (no new tables needed)
function getRoomActiveState(PDO $pdo, string $room_id): array {
  $st = $pdo->prepare("
    SELECT event_name, payload_json, pickup_id, pickup_id_collected_by_player_id, id
    FROM event_queue
    WHERE room_id = ?
    ORDER BY id ASC
    LIMIT " . MAX_SCAN_EVENTS . "
  ");
  $st->execute([$room_id]);

  $activePickups = []; // pickup_id => payload
  $activeWilds   = []; // wild_morty_id => payload
  $activeBots    = []; // bot_id => payload
  $occupiedXY    = []; // "x,y" => true

  while ($r = $st->fetch(PDO::FETCH_ASSOC)) {
    $name = (string)$r["event_name"];
    $payload = json_decode((string)$r["payload_json"], true);
    if (!is_array($payload)) $payload = [];

    // Pickups
    if ($name === "room:pickup-added") {
      $pid = (string)($r["pickup_id"] ?? ($payload["pickup_id"] ?? ""));
      if ($pid !== "") {
        if (!empty($r["pickup_id_collected_by_player_id"])) {
          unset($activePickups[$pid]);
        } else {
          $activePickups[$pid] = $payload;
        }
      }
    }
    if ($name === "room:pickup-removed") {
      $pid = (string)($payload["pickup_id"] ?? "");
      if ($pid !== "") unset($activePickups[$pid]);
    }

    // Wild morties
    if ($name === "room:wild-morty-added") {
      $wid = (string)($payload["wild_morty_id"] ?? "");
      if ($wid !== "") $activeWilds[$wid] = $payload;
    }
    if ($name === "room:wild-morty-removed") {
      $wid = (string)($payload["wild_morty_id"] ?? "");
      if ($wid !== "") unset($activeWilds[$wid]);
    }

    // Bots
    if ($name === "room:bot-added") {
      $bid = (string)($payload["bot_id"] ?? "");
      if ($bid !== "") $activeBots[$bid] = $payload;
    }
    if ($name === "room:bot-removed") {
      $bid = (string)($payload["bot_id"] ?? "");
      if ($bid !== "") unset($activeBots[$bid]);
    }
  }

  // Occupied XY from active entities
  $collect = function(array $payloads) use (&$occupiedXY) {
    foreach ($payloads as $p) {
      if (is_array($p) && isset($p["placement"][0], $p["placement"][1])) {
        $x = (int)$p["placement"][0];
        $y = (int)$p["placement"][1];
        $occupiedXY["$x,$y"] = true;
      }
    }
  };
  $collect($activePickups);
  $collect($activeWilds);
  $collect($activeBots);

  return [
    "pickups" => $activePickups,
    "wilds"   => $activeWilds,
    "bots"    => $activeBots,
    "occupied_xy" => $occupiedXY,
  ];
}

function pickFreePlacement(array $points, array $occupiedXY): array {
  $available = [];
  foreach ($points as $pt) {
    $key = $pt[0] . "," . $pt[1];
    if (!isset($occupiedXY[$key])) $available[] = $pt;
  }
  if (!$available) return [];
  return $available[array_rand($available)];
}

// ---------------- SPAWNERS ----------------
function spawnPickup(PDO $pdo, string $room_id, array &$occupiedXY, array $excludeItemIds = []): bool {
  $placement = pickFreePlacement(PICKUP_POINTS, $occupiedXY);
  if (!$placement) return false;

  $kind = weighted_pick([
    ["value" => "single", "weight" => 70],
    ["value" => "bundle", "weight" => 30],
  ]);

  $contents = [];
  if ($kind === "single") {
    $r = pickRarity();
    $item = pickItemId($r, $excludeItemIds);
    $contents[] = ["type"=>"ITEM","amount"=>1,"item_id"=>$item,"rarity"=>$r];
  } else {
    $n = randInt(2, 4);
    $picked = [];
    for ($i=0; $i<$n; $i++) {
      $r = pickRarity();
      $item = pickItemId($r, array_merge($excludeItemIds, $picked));
      $picked[] = $item;
      $contents[] = ["type"=>"ITEM","amount"=>1,"item_id"=>$item,"rarity"=>$r];
    }
    $contents[] = ["type"=>"COIN","amount"=>randInt(120, 250)];
  }

  $pickup_id = uuidv4();
  $payload = [
    "pickup_id" => $pickup_id,
    "placement" => $placement,
    "contents"  => $contents,
  ];

  publish_event($pdo, $room_id, "room:pickup-added", $payload);
  $occupiedXY[$placement[0] . "," . $placement[1]] = true;
  return true;
}

function spawnWildMorty(PDO $pdo, string $room_id, array &$occupiedXY): bool {
  $placement = pickFreePlacement(MOB_POINTS, $occupiedXY);
  if (!$placement) return false;

  $pool = wildMortyPool();
  $pick = $pool[array_rand($pool)];

  $wild_morty_id = uuidv4();

  // Match the exact "...000Z" format you showed
  $now = gmdate("Y-m-d\\TH:i:s") . ".000Z";

  $payload = [
    "morty_id"         => (string)$pick["morty_id"],
    "placement"        => [(int)$placement[0], (int)$placement[1]],
    "state"            => "WORLD",

    // division: pick a valid range (adjust if your world uses different)
    "division"         => randInt(1, 4),

    "variant"          => (string)($pick["variant"] ?? "Normal"),
    "shiny_if_potion"  => false,

    "_created"         => $now,
    "_updated"         => $now,

    "wild_morty_id"    => $wild_morty_id,
  ];

  publish_event($pdo, $room_id, "room:wild-morty-added", $payload);
  $occupiedXY[$placement[0] . "," . $placement[1]] = true;
  return true;
}

function spawnBot(PDO $pdo, string $room_id, array &$occupiedXY): bool {
  $placement = pickFreePlacement(MOB_POINTS, $occupiedXY);
  if (!$placement) return false;

  $bot_id = uuidv4();

  // zone_id format like "[x-y]"
  $zx = randInt(1, 5);
  $zy = randInt(1, 5);

  $botName  = botNamePool()[array_rand(botNamePool())];
  $botAv    = botAvatarPool()[array_rand(botAvatarPool())];
  $botMorty = botMortyPool()[array_rand(botMortyPool())];

  // IMPORTANT: use player_avatar_id + owned_morties (what the client expects)
  $payload = [
    "username" => $botName,
    "player_avatar_id" => $botAv,
    "state" => "WORLD",
    "level" => randInt(1, 5),

    // give the bot a morty like your original working event
    "owned_morties" => [[
      "morty_id" => $botMorty,
      "variant" => "Normal",
      "hp" => 1,
      "owned_morty_id" => "80700000-0000-0000-0000-000000000000"
    ]],

    "zone" => [
      "player" => [$zx, $zy],
      "bots" => [
        "count" => randInt(6, 12),
        "morty_count" => ["min" => 1, "max" => 1],
        "morty_hp_handicap" => ["min" => 0.4, "max" => 0.6]
      ],
      "zone_id" => "[{$zx}-{$zy}]"
    ],

    "streak" => 0,
    "bot_id" => $bot_id,
    "placement" => $placement
  ];

  publish_event($pdo, $room_id, "room:bot-added", $payload);
  $occupiedXY[$placement[0] . "," . $placement[1]] = true;
  return true;
}

// ---------------- MAIN LOOP ----------------
$out = ["ok" => true, "rooms" => []];

$rooms = $pdo->query("SELECT room_id FROM room_ids")->fetchAll(PDO::FETCH_COLUMN) ?: [];
foreach ($rooms as $room_id) {
  $room_id = (string)$room_id;
  if ($room_id === "") continue;

  $pdo->beginTransaction();
  try {
    $state = getRoomActiveState($pdo, $room_id);

    $activePickups = $state["pickups"];
    $activeWilds   = $state["wilds"];
    $activeBots    = $state["bots"];
    $occupiedXY    = $state["occupied_xy"];

    $spawned = ["pickups" => 0, "wilds" => 0, "bots" => 0];

    // Pickups up to target
    $needPickups = max(0, TARGET_PICKUPS_PER_ROOM - count($activePickups));
    for ($i=0; $i<$needPickups; $i++) {
      $excludeItems = [];
      foreach ($activePickups as $p) {
        if (!empty($p["contents"]) && is_array($p["contents"])) {
          foreach ($p["contents"] as $c) {
            if (is_array($c) && ($c["type"] ?? "") === "ITEM" && !empty($c["item_id"])) {
              $excludeItems[] = (string)$c["item_id"];
            }
          }
        }
      }
      if (!spawnPickup($pdo, $room_id, $occupiedXY, $excludeItems)) break;
      $spawned["pickups"]++;
    }

    // Wild morties up to target
    $needWild = max(0, TARGET_WILD_MORTIES_ROOM - count($activeWilds));
    for ($i=0; $i<$needWild; $i++) {
      if (!spawnWildMorty($pdo, $room_id, $occupiedXY)) break;
      $spawned["wilds"]++;
    }

    // Bots up to target
    $needBots = max(0, TARGET_BOTS_PER_ROOM - count($activeBots));
    for ($i=0; $i<$needBots; $i++) {
      if (!spawnBot($pdo, $room_id, $occupiedXY)) break;
      $spawned["bots"]++;
    }

    $pdo->commit();

    $out["rooms"][] = [
      "room_id" => $room_id,
      "active_before" => [
        "pickups" => count($activePickups),
        "wilds"   => count($activeWilds),
        "bots"    => count($activeBots),
      ],
      "spawned" => $spawned
    ];
  } catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    $out["rooms"][] = ["room_id" => $room_id, "error" => $e->getMessage()];
  }
}

echo json_encode($out, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
