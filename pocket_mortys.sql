-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 10, 2026 at 02:36 AM
-- Server version: 10.11.14-MariaDB-0ubuntu0.24.04.1
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pocket_mortys`
--

-- --------------------------------------------------------

--
-- Table structure for table `decks`
--

CREATE TABLE `decks` (
  `id` int(11) NOT NULL,
  `player_id` text DEFAULT NULL,
  `deck_id` int(11) DEFAULT NULL,
  `owned_morty_ids` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `decks`
--

INSERT INTO `decks` (`id`, `player_id`, `deck_id`, `owned_morty_ids`) VALUES
(1, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 0, '[\"a3e20258-48f8-4602-af17-ad0348c2fbcb\",\"7b3e9d2a-4c61-4f8a-b5e7-1a6d9c2f3e80\",\"edc89405-cfab-42d8-a569-a78444795bfd\",\"52550f1f-b20b-4d89-aaee-ebae2e1f0452\",\"b79e5838-b0f1-4dea-9455-4e983784a246\"]'),
(2, '38d582e2-8942-4110-8144-6d959649c17b', 0, '[\"49b46dfa-1e78-4773-b772-89ac459109b8\"]'),
(3, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 1, '[\"7b3e9d2a-4c61-4f8a-b5e7-1a6d9c2f3e80\"]'),
(4, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 2, '[\"7b3e9d2a-4c61-4f8a-b5e7-1a6d9c2f3e80\",\"a3e20258-48f8-4602-af17-ad0348c2fbcb\",\"71bcabdb-7477-46bd-9c19-9ddba76f1150\",\"6f8b2b8f-3215-4e15-8632-447208b4914b\",\"ead22445-fdff-44ea-8a13-933db5d1f4c0\"]'),
(5, '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', 0, '[\"41d4ea39-6c79-47d6-a64d-fb94f916737c\"]'),
(6, '2e5b5204-defe-42ed-a111-9cf31e985a2f', 0, '[\"43c6a8d9-fbfa-4378-b477-b51664408358\"]'),
(7, '7ac2cc37-441d-4007-b678-ff13ce2280c2', 0, '[\"db3f0f93-27fb-4b51-be50-7f2ad7eaff71\"]');

-- --------------------------------------------------------

--
-- Table structure for table `deck_config`
--

CREATE TABLE `deck_config` (
  `id` int(11) NOT NULL,
  `config_id` text NOT NULL DEFAULT 'MP',
  `starting_deck_slots` int(11) NOT NULL DEFAULT 3,
  `max_deck_slots` int(11) NOT NULL DEFAULT 9,
  `cost_additional_slot` int(11) NOT NULL DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deck_config`
--

INSERT INTO `deck_config` (`id`, `config_id`, `starting_deck_slots`, `max_deck_slots`, `cost_additional_slot`) VALUES
(1, 'MP', 3, 9, 10);

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `raid_event_id` text DEFAULT NULL,
  `shard_id` text DEFAULT NULL,
  `current_state` text NOT NULL,
  `world_id` int(11) DEFAULT NULL,
  `spawn_location` text DEFAULT NULL,
  `boss_id` text DEFAULT NULL,
  `asset_id` text DEFAULT NULL,
  `threat_lvl` int(11) DEFAULT NULL,
  `total_damage` bigint(20) DEFAULT NULL,
  `initial_health` bigint(20) DEFAULT NULL,
  `max_health_bars` bigint(20) DEFAULT NULL,
  `event_state_next_timestamp` timestamp NULL DEFAULT NULL,
  `has_ran` tinyint(1) DEFAULT 0,
  `permit_start` text DEFAULT NULL,
  `permit_buy_in` text DEFAULT NULL,
  `ticket_buy_in` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `raid_event_id`, `shard_id`, `current_state`, `world_id`, `spawn_location`, `boss_id`, `asset_id`, `threat_lvl`, `total_damage`, `initial_health`, `max_health_bars`, `event_state_next_timestamp`, `has_ran`, `permit_start`, `permit_buy_in`, `ticket_buy_in`) VALUES
(1, 'RaidBossKillerAsteroid_2025', '78496e72-fb88-11f0-b2fd-8b24d97da62f', 'active', 1, '37,58', 'killer_asteroid', 'RaidBossKillerAsteroid', 10, 0, 30860800, 60275, '2026-04-13 04:00:00', 0, '50', '1', '0');

-- --------------------------------------------------------

--
-- Table structure for table `event_queue`
--

CREATE TABLE `event_queue` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `room_id` varchar(64) NOT NULL,
  `event_name` varchar(64) NOT NULL,
  `payload_json` longtext NOT NULL,
  `pickup_id` char(36) DEFAULT NULL,
  `player_id` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `pickup_id_collected_by_player_id` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_queue`
--

INSERT INTO `event_queue` (`id`, `room_id`, `event_name`, `payload_json`, `pickup_id`, `player_id`, `created_at`, `pickup_id_collected_by_player_id`) VALUES
(1, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:pickup-added', '{\"pickup_id\":\"7cc8a84c-e7cf-4d75-b566-f9bdc92d10c2\",\"placement\":[25,87],\"contents\":[{\"type\":\"ITEM\",\"amount\":1,\"item_id\":\"ItemTinCan\",\"rarity\":5}]}', '7cc8a84c-e7cf-4d75-b566-f9bdc92d10c2', NULL, '2026-02-10 01:35:31', NULL),
(2, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:pickup-added', '{\"pickup_id\":\"86365932-fca5-413f-800e-28b4bd48e123\",\"placement\":[34,83],\"contents\":[{\"type\":\"ITEM\",\"amount\":1,\"item_id\":\"ItemMegaSeedSpeed\",\"rarity\":5}]}', '86365932-fca5-413f-800e-28b4bd48e123', NULL, '2026-02-10 01:35:31', NULL),
(3, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:pickup-added', '{\"pickup_id\":\"de42e7db-7c88-4746-b7b4-080beeb6afba\",\"placement\":[65,79],\"contents\":[{\"type\":\"ITEM\",\"amount\":1,\"item_id\":\"ItemCable\",\"rarity\":75}]}', 'de42e7db-7c88-4746-b7b4-080beeb6afba', NULL, '2026-02-10 01:35:31', NULL),
(4, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:wild-morty-added', '{\"morty_id\":\"MortyRobotChicken\",\"placement\":[49,84],\"state\":\"WORLD\",\"division\":4,\"variant\":\"Normal\",\"shiny_if_potion\":false,\"_created\":\"2026-02-10T01:35:31.000Z\",\"_updated\":\"2026-02-10T01:35:31.000Z\",\"wild_morty_id\":\"8276a2c7-bf90-404a-92e0-e24791e76804\"}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(5, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:wild-morty-added', '{\"morty_id\":\"MortySoldadoLoco\",\"placement\":[55,79],\"state\":\"WORLD\",\"division\":4,\"variant\":\"Normal\",\"shiny_if_potion\":false,\"_created\":\"2026-02-10T01:35:31.000Z\",\"_updated\":\"2026-02-10T01:35:31.000Z\",\"wild_morty_id\":\"ab2796a5-6f51-474c-b31b-739104a2efc7\"}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(6, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:wild-morty-added', '{\"morty_id\":\"MortyExoPrime\",\"placement\":[32,76],\"state\":\"WORLD\",\"division\":3,\"variant\":\"Normal\",\"shiny_if_potion\":false,\"_created\":\"2026-02-10T01:35:31.000Z\",\"_updated\":\"2026-02-10T01:35:31.000Z\",\"wild_morty_id\":\"411c5c2b-c10d-4ac8-be1c-d36cd0bd7b7a\"}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(7, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:wild-morty-added', '{\"morty_id\":\"MortyRobotChicken\",\"placement\":[24,76],\"state\":\"WORLD\",\"division\":2,\"variant\":\"Normal\",\"shiny_if_potion\":false,\"_created\":\"2026-02-10T01:35:31.000Z\",\"_updated\":\"2026-02-10T01:35:31.000Z\",\"wild_morty_id\":\"6f7f262b-7254-43cf-babf-8f469a81b075\"}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(8, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:bot-added', '{\"username\":\"Carpedge\",\"player_avatar_id\":\"AvatarRickDefault\",\"state\":\"WORLD\",\"level\":3,\"owned_morties\":[{\"morty_id\":\"MortyTyrantLizard\",\"variant\":\"Normal\",\"hp\":1,\"owned_morty_id\":\"80700000-0000-0000-0000-000000000000\"}],\"zone\":{\"player\":[2,3],\"bots\":{\"count\":9,\"morty_count\":{\"min\":1,\"max\":1},\"morty_hp_handicap\":{\"min\":0.4,\"max\":0.6}},\"zone_id\":\"[2-3]\"},\"streak\":0,\"bot_id\":\"609c9b48-e033-4522-9357-5c44b962848f\",\"placement\":[12,84]}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(9, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:bot-added', '{\"username\":\"EasementJustice\",\"player_avatar_id\":\"AvatarRickDefault\",\"state\":\"WORLD\",\"level\":3,\"owned_morties\":[{\"morty_id\":\"MortyGunk\",\"variant\":\"Normal\",\"hp\":1,\"owned_morty_id\":\"80700000-0000-0000-0000-000000000000\"}],\"zone\":{\"player\":[2,3],\"bots\":{\"count\":6,\"morty_count\":{\"min\":1,\"max\":1},\"morty_hp_handicap\":{\"min\":0.4,\"max\":0.6}},\"zone_id\":\"[2-3]\"},\"streak\":0,\"bot_id\":\"27f509c3-5dfb-4703-b066-f135611e485b\",\"placement\":[42,75]}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(10, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:bot-added', '{\"username\":\"Carpedge\",\"player_avatar_id\":\"AvatarBeth\",\"state\":\"WORLD\",\"level\":1,\"owned_morties\":[{\"morty_id\":\"MortyPoorHouse\",\"variant\":\"Normal\",\"hp\":1,\"owned_morty_id\":\"80700000-0000-0000-0000-000000000000\"}],\"zone\":{\"player\":[1,3],\"bots\":{\"count\":12,\"morty_count\":{\"min\":1,\"max\":1},\"morty_hp_handicap\":{\"min\":0.4,\"max\":0.6}},\"zone_id\":\"[1-3]\"},\"streak\":0,\"bot_id\":\"905bd7ea-d3fc-491e-88e3-40ad0d11a4f0\",\"placement\":[37,76]}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(11, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:bot-added', '{\"username\":\"Barbirdation\",\"player_avatar_id\":\"AvatarRickSuperFan\",\"state\":\"WORLD\",\"level\":2,\"owned_morties\":[{\"morty_id\":\"MortyPoorHouse\",\"variant\":\"Normal\",\"hp\":1,\"owned_morty_id\":\"80700000-0000-0000-0000-000000000000\"}],\"zone\":{\"player\":[5,2],\"bots\":{\"count\":10,\"morty_count\":{\"min\":1,\"max\":1},\"morty_hp_handicap\":{\"min\":0.4,\"max\":0.6}},\"zone_id\":\"[5-2]\"},\"streak\":0,\"bot_id\":\"3dffc9ca-9766-4c99-82a1-5acf7e6b096f\",\"placement\":[36,59]}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(12, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:bot-added', '{\"username\":\"ChloeTombola\",\"player_avatar_id\":\"AvatarBeth\",\"state\":\"WORLD\",\"level\":4,\"owned_morties\":[{\"morty_id\":\"MortySoldier\",\"variant\":\"Normal\",\"hp\":1,\"owned_morty_id\":\"80700000-0000-0000-0000-000000000000\"}],\"zone\":{\"player\":[1,2],\"bots\":{\"count\":7,\"morty_count\":{\"min\":1,\"max\":1},\"morty_hp_handicap\":{\"min\":0.4,\"max\":0.6}},\"zone_id\":\"[1-2]\"},\"streak\":0,\"bot_id\":\"b2a3ee59-7b7c-47e4-8f1b-3997da41fa9c\",\"placement\":[47,68]}', NULL, NULL, '2026-02-10 01:35:31', NULL),
(13, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:user-added', '{\"player_id\":\"f8a69ceb-1ef8-4d0b-81dc-d6d59e425163\",\"username\":\"ConspiracyRick\",\"player_avatar_id\":\"AvatarRickEvil\",\"level\":1,\"owned_morties\":[{\"owned_morty_id\":\"7b3e9d2a-4c61-4f8a-b5e7-1a6d9c2f3e80\",\"morty_id\":\"MortyMiami\",\"hp\":20,\"variant\":\"Shiny\",\"is_locked\":false,\"is_trading_locked\":false,\"fight_pit_id\":null}],\"state\":\"WORLD\"}', NULL, NULL, '2026-02-10 01:35:41', NULL),
(14, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'shard:raid-boss-state-changed', '{\"raid_event_id\":\"RaidBossKillerAsteroid_2025\",\"shard_id\":\"78496e72-fb88-11f0-b2fd-8b24d97da62f\",\"current_state\":\"active\",\"world_id\":1,\"spawn_location\":\"37,58\",\"boss_id\":\"killer_asteroid\",\"asset_id\":\"RaidBossKillerAsteroid\",\"threat_lvl\":10,\"total_damage\":\"0\",\"initial_health\":30860800,\"max_health_bars\":60275,\"event_state_next_timestamp\":\"2026-04-13 04:00:00\",\"has_ran\":false,\"permit_start\":50,\"permit_buy_in\":1,\"ticket_buy_in\":0}', NULL, NULL, '2026-02-10 01:35:41', NULL),
(15, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:user-added', '{\"player_id\":\"f8a69ceb-1ef8-4d0b-81dc-d6d59e425163\",\"username\":\"ConspiracyRick\",\"player_avatar_id\":\"AvatarRickEvil\",\"level\":1,\"owned_morties\":[{\"owned_morty_id\":\"7b3e9d2a-4c61-4f8a-b5e7-1a6d9c2f3e80\",\"morty_id\":\"MortyMiami\",\"hp\":20,\"variant\":\"Shiny\",\"is_locked\":false,\"is_trading_locked\":false,\"fight_pit_id\":null}],\"state\":\"WORLD\"}', NULL, NULL, '2026-02-10 01:36:26', NULL),
(16, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'room:user-added', '{\"player_id\":\"f8a69ceb-1ef8-4d0b-81dc-d6d59e425163\",\"username\":\"ConspiracyRick\",\"player_avatar_id\":\"AvatarRickEvil\",\"level\":1,\"owned_morties\":[{\"owned_morty_id\":\"7b3e9d2a-4c61-4f8a-b5e7-1a6d9c2f3e80\",\"morty_id\":\"MortyMiami\",\"hp\":20,\"variant\":\"Shiny\",\"is_locked\":false,\"is_trading_locked\":false,\"fight_pit_id\":null}],\"state\":\"WORLD\"}', NULL, NULL, '2026-02-10 01:42:17', NULL),
(17, '56092cc3-d968-4d2d-8c54-98ed0817hu97', 'shard:raid-boss-state-changed', '{\"raid_event_id\":\"RaidBossKillerAsteroid_2025\",\"shard_id\":\"78496e72-fb88-11f0-b2fd-8b24d97da62f\",\"current_state\":\"active\",\"world_id\":1,\"spawn_location\":\"37,58\",\"boss_id\":\"killer_asteroid\",\"asset_id\":\"RaidBossKillerAsteroid\",\"threat_lvl\":10,\"total_damage\":\"0\",\"initial_health\":30860800,\"max_health_bars\":60275,\"event_state_next_timestamp\":\"2026-04-13 04:00:00\",\"has_ran\":false,\"permit_start\":50,\"permit_buy_in\":1,\"ticket_buy_in\":0}', NULL, NULL, '2026-02-10 01:42:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `friend_list`
--

CREATE TABLE `friend_list` (
  `id` int(11) NOT NULL,
  `player_id_a` text DEFAULT NULL,
  `player_id_b` text DEFAULT NULL,
  `pending` text DEFAULT NULL,
  `direction` text DEFAULT NULL,
  `created` text NOT NULL,
  `modified` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `friend_list`
--

INSERT INTO `friend_list` (`id`, `player_id_a`, `player_id_b`, `pending`, `direction`, `created`, `modified`) VALUES
(1, '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'false', 'false', '2026-02-06T22:09:24.313Z', '2026-02-06 22:10:06');

-- --------------------------------------------------------

--
-- Table structure for table `gachas`
--

CREATE TABLE `gachas` (
  `id` int(11) NOT NULL,
  `gacha_id` varchar(64) NOT NULL,
  `cost` int(11) NOT NULL DEFAULT 0,
  `lvl_min` int(11) NOT NULL,
  `lvl_max` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gachas`
--

INSERT INTO `gachas` (`id`, `gacha_id`, `cost`, `lvl_min`, `lvl_max`) VALUES
(1, 'GachaMPProduct1', 5, 32, 34),
(2, 'GachaMPProduct2', 10, 32, 34),
(3, 'GachaMPProduct3', 30, 32, 34);

-- --------------------------------------------------------

--
-- Table structure for table `gacha_contents`
--

CREATE TABLE `gacha_contents` (
  `id` int(11) NOT NULL,
  `gacha_id` varchar(64) NOT NULL,
  `reward` enum('ITEM','MORTY') NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `division_guarantee` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gacha_contents`
--

INSERT INTO `gacha_contents` (`id`, `gacha_id`, `reward`, `quantity`, `division_guarantee`) VALUES
(1, 'GachaMPProduct1', 'ITEM', 1, NULL),
(2, 'GachaMPProduct1', 'MORTY', 1, NULL),
(3, 'GachaMPProduct1', 'MORTY', 2, 2),
(4, 'GachaMPProduct2', 'MORTY', 1, 3),
(5, 'GachaMPProduct2', 'MORTY', 3, 2),
(6, 'GachaMPProduct2', 'ITEM', 4, NULL),
(7, 'GachaMPProduct2', 'MORTY', 3, NULL),
(8, 'GachaMPProduct3', 'MORTY', 4, 2),
(9, 'GachaMPProduct3', 'MORTY', 3, NULL),
(10, 'GachaMPProduct3', 'MORTY', 1, 4),
(11, 'GachaMPProduct3', 'MORTY', 2, 3),
(12, 'GachaMPProduct3', 'ITEM', 10, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gacha_content_items`
--

CREATE TABLE `gacha_content_items` (
  `id` int(11) NOT NULL,
  `gacha_content_id` int(11) NOT NULL,
  `item_id` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gacha_content_items`
--

INSERT INTO `gacha_content_items` (`id`, `gacha_content_id`, `item_id`) VALUES
(1, 1, 'ItemMortyChip'),
(2, 1, 'ItemPureSerum'),
(3, 1, 'ItemHalzinger'),
(4, 1, 'ItemPureHalzinger'),
(5, 1, 'ItemFullRecover'),
(6, 1, 'ItemMrMeeseek'),
(7, 1, 'ItemMegaSeedAttack'),
(8, 1, 'ItemMegaSeedDefence'),
(9, 1, 'ItemMegaSeedSpeed'),
(10, 1, 'ItemMegaSeedLevelUp'),
(11, 6, 'ItemMortyChip'),
(12, 6, 'ItemPureSerum'),
(13, 6, 'ItemHalzinger'),
(14, 6, 'ItemPureHalzinger'),
(15, 6, 'ItemFullRecover'),
(16, 6, 'ItemMrMeeseek'),
(17, 6, 'ItemMegaSeedAttack'),
(18, 6, 'ItemMegaSeedDefence'),
(19, 6, 'ItemMegaSeedSpeed'),
(20, 6, 'ItemMegaSeedLevelUp'),
(21, 12, 'ItemMortyChip'),
(22, 12, 'ItemPureSerum'),
(23, 12, 'ItemHalzinger'),
(24, 12, 'ItemPureHalzinger'),
(25, 12, 'ItemFullRecover'),
(26, 12, 'ItemMrMeeseek'),
(27, 12, 'ItemMegaSeedAttack'),
(28, 12, 'ItemMegaSeedDefence'),
(29, 12, 'ItemMegaSeedSpeed'),
(30, 12, 'ItemMegaSeedLevelUp');

-- --------------------------------------------------------

--
-- Table structure for table `gacha_drop_rates`
--

CREATE TABLE `gacha_drop_rates` (
  `id` int(11) NOT NULL,
  `gacha_promo_id` varchar(64) NOT NULL,
  `division` int(11) NOT NULL,
  `chance` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gacha_drop_rates`
--

INSERT INTO `gacha_drop_rates` (`id`, `gacha_promo_id`, `division`, `chance`) VALUES
(1, 'GachaMPPromo20230207_2026', 1, 80),
(2, 'GachaMPPromo20230207_2026', 2, 12),
(3, 'GachaMPPromo20230207_2026', 3, 6),
(4, 'GachaMPPromo20230207_2026', 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `gacha_promos`
--

CREATE TABLE `gacha_promos` (
  `id` int(11) NOT NULL,
  `gacha_promo_id` varchar(64) NOT NULL,
  `period_start` int(11) NOT NULL,
  `period_end` int(11) NOT NULL,
  `image_url` text DEFAULT NULL,
  `drop_chance` decimal(8,6) NOT NULL DEFAULT 0.000000,
  `gacha_promo_chance` decimal(8,6) NOT NULL DEFAULT 0.000000,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gacha_promos`
--

INSERT INTO `gacha_promos` (`id`, `gacha_promo_id`, `period_start`, `period_end`, `image_url`, `drop_chance`, `gacha_promo_chance`, `created_at`) VALUES
(1, 'GachaMPPromo20230207_2026', 1769438400, 1780042600, 'https://assets.bps-pmnet.com/Media/Promos/GachaBackgrounds/Cust1605801458922.png', 0.060000, 0.060000, '2026-02-05 21:09:03');

-- --------------------------------------------------------

--
-- Table structure for table `gacha_promo_attack_effects`
--

CREATE TABLE `gacha_promo_attack_effects` (
  `id` int(11) NOT NULL,
  `promo_attack_id` int(11) NOT NULL,
  `effect_type` varchar(32) NOT NULL,
  `stat` varchar(32) DEFAULT NULL,
  `power` int(11) DEFAULT NULL,
  `accuracy` decimal(6,4) DEFAULT NULL,
  `to_self` tinyint(1) DEFAULT NULL,
  `continue_on_miss` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gacha_promo_attack_effects`
--

INSERT INTO `gacha_promo_attack_effects` (`id`, `promo_attack_id`, `effect_type`, `stat`, `power`, `accuracy`, `to_self`, `continue_on_miss`) VALUES
(1, 1, 'Stat', 'Accuracy', 3, 0.9500, 1, NULL),
(2, 2, 'Hit', NULL, 85, 0.9500, NULL, 0),
(3, 2, 'Poison', NULL, NULL, 1.0000, NULL, NULL),
(4, 3, 'Stat', 'Speed', -2, 0.9500, NULL, NULL),
(5, 4, 'Hit', NULL, 90, 0.7500, NULL, 0),
(6, 4, 'Stat', 'Speed', 1, 0.7500, 1, NULL),
(7, 4, 'Stat', 'Attack', 1, 0.7500, 1, NULL),
(8, 5, 'Hit', NULL, 95, 0.9000, NULL, NULL),
(9, 6, 'Stat', 'Defence', 2, 0.9500, 1, NULL),
(10, 7, 'Hit', NULL, 15, 0.9500, NULL, NULL),
(11, 7, 'Hit', NULL, 20, NULL, NULL, NULL),
(12, 7, 'Hit', NULL, 30, 0.8000, NULL, NULL),
(13, 7, 'Hit', NULL, 35, 0.5000, NULL, NULL),
(14, 8, 'Stat', 'Attack', 2, 0.9500, 1, NULL),
(15, 9, 'Stat', 'Accuracy', 2, 0.8000, 1, NULL),
(16, 9, 'Stat', 'Attack', 2, 0.8000, 1, NULL),
(17, 10, 'Hit', NULL, 120, 0.9500, NULL, NULL),
(18, 11, 'Hit', NULL, 100, 0.9500, NULL, NULL),
(19, 12, 'Stat', 'Accuracy', 2, 0.9500, 1, NULL),
(20, 13, 'Stat', 'Defence', 2, NULL, 1, NULL),
(21, 13, 'Paralyse', NULL, NULL, 0.5000, NULL, 0),
(22, 13, 'Paralyse', NULL, NULL, NULL, 1, NULL),
(23, 14, 'Hit', NULL, 90, 0.9500, NULL, NULL),
(24, 15, 'Stat', 'Defence', 3, 0.9500, 1, NULL),
(25, 16, 'Paralyse', NULL, NULL, 0.6000, NULL, 0),
(26, 16, 'Stat', 'Attack', -1, NULL, NULL, NULL),
(27, 17, 'Hit', NULL, 50, 0.9000, NULL, NULL),
(28, 17, 'Hit', NULL, 50, 0.9000, NULL, 0),
(29, 17, 'Stat', 'Defence', -1, 0.9500, NULL, NULL),
(30, 18, 'Hit', NULL, 100, 0.8000, NULL, NULL),
(31, 19, 'Stat', 'Attack', 3, 0.9500, 1, NULL),
(32, 20, 'Stat', 'Defence', 3, 0.9500, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gacha_promo_mortys`
--

CREATE TABLE `gacha_promo_mortys` (
  `id` int(11) NOT NULL,
  `gacha_promo_id` varchar(64) NOT NULL,
  `morty_id` varchar(64) NOT NULL,
  `variant` varchar(16) NOT NULL DEFAULT 'Normal',
  `lvl_min` int(11) NOT NULL,
  `lvl_max` int(11) NOT NULL,
  `hp_min` int(11) NOT NULL,
  `hp_max` int(11) NOT NULL,
  `atk_min` int(11) NOT NULL,
  `atk_max` int(11) NOT NULL,
  `def_min` int(11) NOT NULL,
  `def_max` int(11) NOT NULL,
  `spd_min` int(11) NOT NULL,
  `spd_max` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gacha_promo_mortys`
--

INSERT INTO `gacha_promo_mortys` (`id`, `gacha_promo_id`, `morty_id`, `variant`, `lvl_min`, `lvl_max`, `hp_min`, `hp_max`, `atk_min`, `atk_max`, `def_min`, `def_max`, `spd_min`, `spd_max`) VALUES
(1, 'GachaMPPromo20230207_2026', 'MortyBirdingMan', 'Normal', 32, 34, 86, 101, 50, 63, 60, 73, 46, 59),
(2, 'GachaMPPromo20230207_2026', 'MortyChick', 'Normal', 32, 34, 103, 119, 60, 73, 66, 80, 69, 83),
(3, 'GachaMPPromo20230207_2026', 'MortyRobotChicken', 'Normal', 32, 34, 103, 119, 50, 63, 66, 80, 76, 90),
(4, 'GachaMPPromo20230207_2026', 'MortyDrone', 'Normal', 32, 34, 106, 122, 69, 83, 69, 83, 69, 83),
(5, 'GachaMPPromo20230207_2026', 'MortyTurkerSoldier', 'Normal', 32, 34, 98, 114, 50, 63, 49, 62, 50, 63);

-- --------------------------------------------------------

--
-- Table structure for table `gacha_promo_morty_attacks`
--

CREATE TABLE `gacha_promo_morty_attacks` (
  `id` int(11) NOT NULL,
  `gacha_promo_id` varchar(64) NOT NULL,
  `morty_id` varchar(64) NOT NULL,
  `position` int(11) NOT NULL,
  `attack_id` varchar(64) NOT NULL,
  `pp` int(11) NOT NULL,
  `pp_stat` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gacha_promo_morty_attacks`
--

INSERT INTO `gacha_promo_morty_attacks` (`id`, `gacha_promo_id`, `morty_id`, `position`, `attack_id`, `pp`, `pp_stat`) VALUES
(1, 'GachaMPPromo20230207_2026', 'MortyBirdingMan', 0, 'AttackSparkle', 10, 10),
(2, 'GachaMPPromo20230207_2026', 'MortyBirdingMan', 1, 'AttackArtsyFartsy', 5, 5),
(3, 'GachaMPPromo20230207_2026', 'MortyBirdingMan', 2, 'AttackStarGaze', 15, 15),
(4, 'GachaMPPromo20230207_2026', 'MortyBirdingMan', 3, 'AttackUpbeat', 10, 10),
(5, 'GachaMPPromo20230207_2026', 'MortyChick', 0, 'AttackServingUp', 8, 8),
(6, 'GachaMPPromo20230207_2026', 'MortyChick', 1, 'AttackHarden', 15, 15),
(7, 'GachaMPPromo20230207_2026', 'MortyChick', 2, 'AttackWetTongue', 5, 5),
(8, 'GachaMPPromo20230207_2026', 'MortyChick', 3, 'AttackSalivate', 15, 15),
(9, 'GachaMPPromo20230207_2026', 'MortyRobotChicken', 0, 'AttackLaserStare', 8, 8),
(10, 'GachaMPPromo20230207_2026', 'MortyRobotChicken', 1, 'AttackDinnerTime', 5, 5),
(11, 'GachaMPPromo20230207_2026', 'MortyRobotChicken', 2, 'AttackFlutter', 8, 8),
(12, 'GachaMPPromo20230207_2026', 'MortyRobotChicken', 3, 'AttackBlink', 12, 12),
(13, 'GachaMPPromo20230207_2026', 'MortyDrone', 0, 'AttackStaticShock', 5, 5),
(14, 'GachaMPPromo20230207_2026', 'MortyDrone', 1, 'AttackCrush', 8, 8),
(15, 'GachaMPPromo20230207_2026', 'MortyDrone', 2, 'AttackWall', 10, 10),
(16, 'GachaMPPromo20230207_2026', 'MortyDrone', 3, 'AttackGrab', 5, 5),
(17, 'GachaMPPromo20230207_2026', 'MortyTurkerSoldier', 0, 'AttackPerchAndPoop', 10, 10),
(18, 'GachaMPPromo20230207_2026', 'MortyTurkerSoldier', 1, 'AttackGobbleTango', 5, 5),
(19, 'GachaMPPromo20230207_2026', 'MortyTurkerSoldier', 2, 'AttackPray', 10, 10),
(20, 'GachaMPPromo20230207_2026', 'MortyTurkerSoldier', 3, 'AttackDefend', 10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `mortydex`
--

CREATE TABLE `mortydex` (
  `id` int(11) NOT NULL,
  `player_id` text DEFAULT NULL,
  `morty_id` text DEFAULT NULL,
  `caught` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mortydex`
--

INSERT INTO `mortydex` (`id`, `player_id`, `morty_id`, `caught`) VALUES
(1, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyDefault', 'true'),
(2, '38d582e2-8942-4110-8144-6d959649c17b', 'MortyDefault', 'true'),
(3, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyMiami', 'true'),
(4, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyRobotChicken', 'true'),
(5, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyCrow', 'true'),
(6, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyMulti', 'true'),
(7, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyExoPrime', 'true'),
(8, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyCrying', 'true'),
(9, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyPrisoner', 'true'),
(10, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortySoldadoLoco', 'true'),
(11, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyTeaCup', 'true'),
(12, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyFelon', 'true'),
(13, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyChick', 'true'),
(14, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyDrone', 'true'),
(15, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyTurkerSoldier', 'true'),
(16, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'MortyBirdingMan', 'true'),
(17, '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', 'MortyDefault', 'true'),
(18, '2e5b5204-defe-42ed-a111-9cf31e985a2f', 'MortyDefault', 'true'),
(19, '7ac2cc37-441d-4007-b678-ff13ce2280c2', 'MortyDefault', 'true');

-- --------------------------------------------------------

--
-- Table structure for table `owned_attacks`
--

CREATE TABLE `owned_attacks` (
  `id` int(11) NOT NULL,
  `owned_morty_id` varchar(255) DEFAULT NULL,
  `attack_id` text DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `pp` int(11) DEFAULT NULL,
  `pp_stat` int(11) DEFAULT NULL,
  `stat` text DEFAULT NULL,
  `type` text DEFAULT NULL,
  `to_self` int(11) DEFAULT NULL,
  `is_accurate` int(11) DEFAULT NULL,
  `accuracy` tinyint(1) DEFAULT NULL,
  `power` bigint(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `owned_attacks`
--

INSERT INTO `owned_attacks` (`id`, `owned_morty_id`, `attack_id`, `position`, `amount`, `pp`, `pp_stat`, `stat`, `type`, `to_self`, `is_accurate`, `accuracy`, `power`) VALUES
(1, 'a3e20258-48f8-4602-af17-ad0348c2fbcb', 'AttackOutburst', 0, NULL, 12, 12, 'Hit', 'Attack', 0, 1, 95, 50),
(2, '49b46dfa-1e78-4773-b772-89ac459109b8', 'AttackOutburst', 0, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(3, '71bcabdb-7477-46bd-9c19-9ddba76f1150', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(4, '71bcabdb-7477-46bd-9c19-9ddba76f1150', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(5, '71bcabdb-7477-46bd-9c19-9ddba76f1150', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(6, '71bcabdb-7477-46bd-9c19-9ddba76f1150', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(7, '6f8b2b8f-3215-4e15-8632-447208b4914b', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(8, '6f8b2b8f-3215-4e15-8632-447208b4914b', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(9, '6f8b2b8f-3215-4e15-8632-447208b4914b', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(10, '6f8b2b8f-3215-4e15-8632-447208b4914b', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'ead22445-fdff-44ea-8a13-933db5d1f4c0', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 'ead22445-fdff-44ea-8a13-933db5d1f4c0', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 'ead22445-fdff-44ea-8a13-933db5d1f4c0', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'ead22445-fdff-44ea-8a13-933db5d1f4c0', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(15, '2dabef00-24d4-40ae-9ff8-d1c93cdd1146', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(16, '2dabef00-24d4-40ae-9ff8-d1c93cdd1146', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(17, '2dabef00-24d4-40ae-9ff8-d1c93cdd1146', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(18, '2dabef00-24d4-40ae-9ff8-d1c93cdd1146', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(19, '2a004853-b0f4-4bac-8896-16a80e2c34b2', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(20, '2a004853-b0f4-4bac-8896-16a80e2c34b2', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(21, '2a004853-b0f4-4bac-8896-16a80e2c34b2', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(22, '2a004853-b0f4-4bac-8896-16a80e2c34b2', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(23, '03986945-f571-40ea-a06f-3ef49074b9e8', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(24, '03986945-f571-40ea-a06f-3ef49074b9e8', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(25, '03986945-f571-40ea-a06f-3ef49074b9e8', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(26, '03986945-f571-40ea-a06f-3ef49074b9e8', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(27, '26190714-3b6e-4191-95d9-7f6686be9474', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(28, '26190714-3b6e-4191-95d9-7f6686be9474', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(29, '26190714-3b6e-4191-95d9-7f6686be9474', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(30, '26190714-3b6e-4191-95d9-7f6686be9474', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(31, '52550f1f-b20b-4d89-aaee-ebae2e1f0452', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(32, '52550f1f-b20b-4d89-aaee-ebae2e1f0452', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(33, '52550f1f-b20b-4d89-aaee-ebae2e1f0452', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(34, '52550f1f-b20b-4d89-aaee-ebae2e1f0452', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(35, 'd3990041-d3c0-4153-8915-1e2a10728a88', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(36, 'd3990041-d3c0-4153-8915-1e2a10728a88', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(37, 'd3990041-d3c0-4153-8915-1e2a10728a88', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(38, 'd3990041-d3c0-4153-8915-1e2a10728a88', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(39, '89dafefa-6075-4076-8b9b-78b3b21c1b71', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(40, '89dafefa-6075-4076-8b9b-78b3b21c1b71', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(41, '89dafefa-6075-4076-8b9b-78b3b21c1b71', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(42, '89dafefa-6075-4076-8b9b-78b3b21c1b71', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(43, '2e3bc859-b1ca-4e15-98ed-d9c13f86e77e', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(44, '2e3bc859-b1ca-4e15-98ed-d9c13f86e77e', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(45, '2e3bc859-b1ca-4e15-98ed-d9c13f86e77e', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(46, '2e3bc859-b1ca-4e15-98ed-d9c13f86e77e', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(47, '88c73396-2b61-4edb-aa6e-cbac6409a6e0', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(48, '88c73396-2b61-4edb-aa6e-cbac6409a6e0', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(49, '88c73396-2b61-4edb-aa6e-cbac6409a6e0', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(50, '88c73396-2b61-4edb-aa6e-cbac6409a6e0', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(51, 'd893c384-33a2-4966-9848-365068a6251c', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(52, 'd893c384-33a2-4966-9848-365068a6251c', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(53, 'd893c384-33a2-4966-9848-365068a6251c', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(54, 'd893c384-33a2-4966-9848-365068a6251c', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(55, '3fcfd114-b6e6-4851-bc0d-48b866fe5b44', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(56, '3fcfd114-b6e6-4851-bc0d-48b866fe5b44', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(57, '3fcfd114-b6e6-4851-bc0d-48b866fe5b44', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(58, '3fcfd114-b6e6-4851-bc0d-48b866fe5b44', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(59, '58f8572d-04f3-4820-88e5-3b37ca96c828', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(60, '58f8572d-04f3-4820-88e5-3b37ca96c828', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(61, '58f8572d-04f3-4820-88e5-3b37ca96c828', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(62, '58f8572d-04f3-4820-88e5-3b37ca96c828', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(63, 'b5cef065-9547-42bf-81a9-baf3c6afeab2', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(64, 'b5cef065-9547-42bf-81a9-baf3c6afeab2', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(65, 'b5cef065-9547-42bf-81a9-baf3c6afeab2', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(66, 'b5cef065-9547-42bf-81a9-baf3c6afeab2', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(67, 'aca7b066-98a4-4943-ab72-010948a37f7b', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(68, 'aca7b066-98a4-4943-ab72-010948a37f7b', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(69, 'aca7b066-98a4-4943-ab72-010948a37f7b', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(70, 'aca7b066-98a4-4943-ab72-010948a37f7b', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(71, '40d0b542-c38a-4030-b612-ba4f893f32f8', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(72, '40d0b542-c38a-4030-b612-ba4f893f32f8', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(73, '40d0b542-c38a-4030-b612-ba4f893f32f8', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(74, '40d0b542-c38a-4030-b612-ba4f893f32f8', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(75, 'f9d3c8f9-cfd4-45df-94da-abda611bb540', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(76, 'f9d3c8f9-cfd4-45df-94da-abda611bb540', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(77, 'f9d3c8f9-cfd4-45df-94da-abda611bb540', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(78, 'f9d3c8f9-cfd4-45df-94da-abda611bb540', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(79, '22d64b02-b257-4bcf-b1a4-71cce452c3f3', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(80, '22d64b02-b257-4bcf-b1a4-71cce452c3f3', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(81, '22d64b02-b257-4bcf-b1a4-71cce452c3f3', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(82, '22d64b02-b257-4bcf-b1a4-71cce452c3f3', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(83, 'edc89405-cfab-42d8-a569-a78444795bfd', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(84, 'edc89405-cfab-42d8-a569-a78444795bfd', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(85, 'edc89405-cfab-42d8-a569-a78444795bfd', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(86, 'edc89405-cfab-42d8-a569-a78444795bfd', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(87, '40dec3d6-97fc-4d41-8d31-cae0648b8547', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(88, '40dec3d6-97fc-4d41-8d31-cae0648b8547', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(89, '40dec3d6-97fc-4d41-8d31-cae0648b8547', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(90, '40dec3d6-97fc-4d41-8d31-cae0648b8547', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(91, '93c9f392-b917-4443-9d6a-f2732cbb8668', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(92, '93c9f392-b917-4443-9d6a-f2732cbb8668', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(93, '93c9f392-b917-4443-9d6a-f2732cbb8668', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(94, '93c9f392-b917-4443-9d6a-f2732cbb8668', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(95, '8a26b551-fcc8-4c38-b106-724b2fcb09dd', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(96, '8a26b551-fcc8-4c38-b106-724b2fcb09dd', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(97, '8a26b551-fcc8-4c38-b106-724b2fcb09dd', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(98, '8a26b551-fcc8-4c38-b106-724b2fcb09dd', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(99, '414f7c1c-2eac-4787-92c7-ada880e15e17', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(100, '414f7c1c-2eac-4787-92c7-ada880e15e17', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(101, '414f7c1c-2eac-4787-92c7-ada880e15e17', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(102, '414f7c1c-2eac-4787-92c7-ada880e15e17', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(103, 'ad141b79-6a55-4468-a006-51ee988c9f3a', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(104, 'ad141b79-6a55-4468-a006-51ee988c9f3a', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(105, 'ad141b79-6a55-4468-a006-51ee988c9f3a', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(106, 'ad141b79-6a55-4468-a006-51ee988c9f3a', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(107, '3b9ed302-36c7-46a4-b49b-cd677df9a6fc', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(108, '3b9ed302-36c7-46a4-b49b-cd677df9a6fc', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(109, '3b9ed302-36c7-46a4-b49b-cd677df9a6fc', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(110, '3b9ed302-36c7-46a4-b49b-cd677df9a6fc', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(111, '289ca58e-a886-47b9-95be-82f955921202', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(112, '289ca58e-a886-47b9-95be-82f955921202', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(113, '289ca58e-a886-47b9-95be-82f955921202', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(114, '289ca58e-a886-47b9-95be-82f955921202', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(115, 'b79e5838-b0f1-4dea-9455-4e983784a246', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(116, 'b79e5838-b0f1-4dea-9455-4e983784a246', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(117, 'b79e5838-b0f1-4dea-9455-4e983784a246', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(118, 'b79e5838-b0f1-4dea-9455-4e983784a246', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(119, 'a13e1bff-2ba9-4472-85e3-e8eaffd575f7', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(120, 'a13e1bff-2ba9-4472-85e3-e8eaffd575f7', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(121, 'a13e1bff-2ba9-4472-85e3-e8eaffd575f7', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(122, 'a13e1bff-2ba9-4472-85e3-e8eaffd575f7', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(123, '27751068-2269-4b09-9671-c3e4ea5c950e', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(124, '27751068-2269-4b09-9671-c3e4ea5c950e', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(125, '27751068-2269-4b09-9671-c3e4ea5c950e', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(126, '27751068-2269-4b09-9671-c3e4ea5c950e', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(127, '570ef060-ea81-4fff-a42f-32443a2c9b1c', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(128, '570ef060-ea81-4fff-a42f-32443a2c9b1c', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(129, '570ef060-ea81-4fff-a42f-32443a2c9b1c', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(130, '570ef060-ea81-4fff-a42f-32443a2c9b1c', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(131, 'aa764c3b-e7cc-499b-a7aa-5eb14ee7bc13', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(132, 'aa764c3b-e7cc-499b-a7aa-5eb14ee7bc13', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(133, 'aa764c3b-e7cc-499b-a7aa-5eb14ee7bc13', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(134, 'aa764c3b-e7cc-499b-a7aa-5eb14ee7bc13', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(135, '15a1e146-0c73-4d3c-b5f4-e2d77c387ac0', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(136, '15a1e146-0c73-4d3c-b5f4-e2d77c387ac0', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(137, '15a1e146-0c73-4d3c-b5f4-e2d77c387ac0', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(138, '15a1e146-0c73-4d3c-b5f4-e2d77c387ac0', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(139, 'ab247161-da2e-4f10-9ada-a7bdc9b68507', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(140, 'ab247161-da2e-4f10-9ada-a7bdc9b68507', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(141, 'ab247161-da2e-4f10-9ada-a7bdc9b68507', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(142, 'ab247161-da2e-4f10-9ada-a7bdc9b68507', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(143, '8f12a1ae-82f8-446a-8fe7-89dd5a9da958', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(144, '8f12a1ae-82f8-446a-8fe7-89dd5a9da958', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(145, '8f12a1ae-82f8-446a-8fe7-89dd5a9da958', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(146, '8f12a1ae-82f8-446a-8fe7-89dd5a9da958', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(147, 'dc97a146-14ad-45de-851c-24533d5c895a', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(148, 'dc97a146-14ad-45de-851c-24533d5c895a', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(149, 'dc97a146-14ad-45de-851c-24533d5c895a', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(150, 'dc97a146-14ad-45de-851c-24533d5c895a', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(151, '047d1551-12c7-4e6e-8e34-e7e3e317dd34', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(152, '047d1551-12c7-4e6e-8e34-e7e3e317dd34', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(153, '047d1551-12c7-4e6e-8e34-e7e3e317dd34', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(154, '047d1551-12c7-4e6e-8e34-e7e3e317dd34', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(155, '44b83c78-921a-4226-90ca-42d26e50a82a', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(156, '44b83c78-921a-4226-90ca-42d26e50a82a', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(157, '44b83c78-921a-4226-90ca-42d26e50a82a', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(158, '44b83c78-921a-4226-90ca-42d26e50a82a', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(159, '05d16496-4dcb-469e-9cea-8a5c058c48f6', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(160, '05d16496-4dcb-469e-9cea-8a5c058c48f6', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(161, '05d16496-4dcb-469e-9cea-8a5c058c48f6', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(162, '05d16496-4dcb-469e-9cea-8a5c058c48f6', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(163, 'af079653-3ffb-4a40-8c86-3d1de952f8c3', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(164, 'af079653-3ffb-4a40-8c86-3d1de952f8c3', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(165, 'af079653-3ffb-4a40-8c86-3d1de952f8c3', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(166, 'af079653-3ffb-4a40-8c86-3d1de952f8c3', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(167, '04d58042-9dd6-4d2c-afdc-bdf307ef32b9', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(168, '04d58042-9dd6-4d2c-afdc-bdf307ef32b9', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(169, '04d58042-9dd6-4d2c-afdc-bdf307ef32b9', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(170, '04d58042-9dd6-4d2c-afdc-bdf307ef32b9', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(171, 'f926169c-5902-46f1-9404-f25379b66a09', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(172, 'f926169c-5902-46f1-9404-f25379b66a09', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(173, 'f926169c-5902-46f1-9404-f25379b66a09', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(174, 'f926169c-5902-46f1-9404-f25379b66a09', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(175, '34c9bb9c-ada1-497d-a7a7-59aa8361fc54', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(176, '34c9bb9c-ada1-497d-a7a7-59aa8361fc54', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(177, '34c9bb9c-ada1-497d-a7a7-59aa8361fc54', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(178, '34c9bb9c-ada1-497d-a7a7-59aa8361fc54', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(179, 'aad4a06f-c1ca-4c96-9e8b-ef1c2abbc039', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(180, 'aad4a06f-c1ca-4c96-9e8b-ef1c2abbc039', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(181, 'aad4a06f-c1ca-4c96-9e8b-ef1c2abbc039', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(182, 'aad4a06f-c1ca-4c96-9e8b-ef1c2abbc039', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(183, '19bf7c0a-17b5-4819-a110-d1dfa1a3411e', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(184, '19bf7c0a-17b5-4819-a110-d1dfa1a3411e', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(185, '19bf7c0a-17b5-4819-a110-d1dfa1a3411e', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(186, '19bf7c0a-17b5-4819-a110-d1dfa1a3411e', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(187, '85935091-4c8b-4de8-aa05-8c6255bdeb49', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(188, '85935091-4c8b-4de8-aa05-8c6255bdeb49', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(189, '85935091-4c8b-4de8-aa05-8c6255bdeb49', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(190, '85935091-4c8b-4de8-aa05-8c6255bdeb49', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(191, '64d6a054-2ada-40d1-9f8f-623e2d433b3e', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(192, '64d6a054-2ada-40d1-9f8f-623e2d433b3e', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(193, '64d6a054-2ada-40d1-9f8f-623e2d433b3e', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(194, '64d6a054-2ada-40d1-9f8f-623e2d433b3e', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(195, '392ad226-786d-47e7-b032-6603bde53d84', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(196, '392ad226-786d-47e7-b032-6603bde53d84', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(197, '392ad226-786d-47e7-b032-6603bde53d84', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(198, '392ad226-786d-47e7-b032-6603bde53d84', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(199, 'd4f4a9e8-539e-4d2f-8fb2-c57ba07055fe', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(200, 'd4f4a9e8-539e-4d2f-8fb2-c57ba07055fe', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(201, 'd4f4a9e8-539e-4d2f-8fb2-c57ba07055fe', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(202, 'd4f4a9e8-539e-4d2f-8fb2-c57ba07055fe', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(203, '7731f95e-1bd8-4075-a977-eafe1bb78b6b', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(204, '7731f95e-1bd8-4075-a977-eafe1bb78b6b', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(205, '7731f95e-1bd8-4075-a977-eafe1bb78b6b', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(206, '7731f95e-1bd8-4075-a977-eafe1bb78b6b', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(207, 'ae627f4a-6729-4e25-8a2c-449cb39b2010', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(208, 'ae627f4a-6729-4e25-8a2c-449cb39b2010', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(209, 'ae627f4a-6729-4e25-8a2c-449cb39b2010', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(210, 'ae627f4a-6729-4e25-8a2c-449cb39b2010', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(211, '66097460-3c3c-4a24-956e-67e097ef00a1', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(212, '66097460-3c3c-4a24-956e-67e097ef00a1', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(213, '66097460-3c3c-4a24-956e-67e097ef00a1', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(214, '66097460-3c3c-4a24-956e-67e097ef00a1', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(215, 'e9c6b9c0-fb54-4b3a-bb0b-4afe6b799332', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(216, 'e9c6b9c0-fb54-4b3a-bb0b-4afe6b799332', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(217, 'e9c6b9c0-fb54-4b3a-bb0b-4afe6b799332', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(218, 'e9c6b9c0-fb54-4b3a-bb0b-4afe6b799332', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(219, 'e3262a5f-634d-42bd-a9b0-4b74d418c898', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(220, 'e3262a5f-634d-42bd-a9b0-4b74d418c898', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(221, 'e3262a5f-634d-42bd-a9b0-4b74d418c898', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(222, 'e3262a5f-634d-42bd-a9b0-4b74d418c898', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(223, 'bc4570e8-5030-49e2-bd70-9c6f6c87d239', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(224, 'bc4570e8-5030-49e2-bd70-9c6f6c87d239', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(225, 'bc4570e8-5030-49e2-bd70-9c6f6c87d239', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(226, 'bc4570e8-5030-49e2-bd70-9c6f6c87d239', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(227, '77e64578-b882-4b6e-8e3f-ada448d585f0', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(228, '77e64578-b882-4b6e-8e3f-ada448d585f0', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(229, '77e64578-b882-4b6e-8e3f-ada448d585f0', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(230, '77e64578-b882-4b6e-8e3f-ada448d585f0', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(231, '95d39a19-07f2-4e68-b766-2360aa476426', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(232, '95d39a19-07f2-4e68-b766-2360aa476426', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(233, '95d39a19-07f2-4e68-b766-2360aa476426', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(234, '95d39a19-07f2-4e68-b766-2360aa476426', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(235, 'c95e71ae-7c6f-4710-a51c-07e7833a563d', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(236, 'c95e71ae-7c6f-4710-a51c-07e7833a563d', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(237, 'c95e71ae-7c6f-4710-a51c-07e7833a563d', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(238, 'c95e71ae-7c6f-4710-a51c-07e7833a563d', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(239, 'e23e698f-7061-4edf-b36c-209b5712b717', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(240, 'e23e698f-7061-4edf-b36c-209b5712b717', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(241, 'e23e698f-7061-4edf-b36c-209b5712b717', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(242, 'e23e698f-7061-4edf-b36c-209b5712b717', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(243, '77215d16-eecd-48c9-9560-1889381848e9', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(244, '77215d16-eecd-48c9-9560-1889381848e9', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(245, '77215d16-eecd-48c9-9560-1889381848e9', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(246, '77215d16-eecd-48c9-9560-1889381848e9', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(247, '1e0b1d8e-50e3-4e62-a85c-af3a4ea59e18', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(248, '1e0b1d8e-50e3-4e62-a85c-af3a4ea59e18', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(249, '1e0b1d8e-50e3-4e62-a85c-af3a4ea59e18', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(250, '1e0b1d8e-50e3-4e62-a85c-af3a4ea59e18', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(251, 'd11c07cb-98a9-45da-bdcf-90c8ddebeab1', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(252, 'd11c07cb-98a9-45da-bdcf-90c8ddebeab1', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(253, 'd11c07cb-98a9-45da-bdcf-90c8ddebeab1', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(254, 'd11c07cb-98a9-45da-bdcf-90c8ddebeab1', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(255, 'd7328f39-e8a5-4335-9da3-2b639257abc1', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(256, 'd7328f39-e8a5-4335-9da3-2b639257abc1', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(257, 'd7328f39-e8a5-4335-9da3-2b639257abc1', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(258, 'd7328f39-e8a5-4335-9da3-2b639257abc1', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(259, 'b71cd49f-ac73-40f8-9db6-5fd8cbefdbec', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(260, 'b71cd49f-ac73-40f8-9db6-5fd8cbefdbec', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(261, 'b71cd49f-ac73-40f8-9db6-5fd8cbefdbec', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(262, 'b71cd49f-ac73-40f8-9db6-5fd8cbefdbec', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(263, '16787d00-674f-43f5-ac4b-b16c7a29499b', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(264, '16787d00-674f-43f5-ac4b-b16c7a29499b', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(265, '16787d00-674f-43f5-ac4b-b16c7a29499b', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(266, '16787d00-674f-43f5-ac4b-b16c7a29499b', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(267, '3482a937-8236-4f1a-8324-d4bdf3a586bd', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(268, '3482a937-8236-4f1a-8324-d4bdf3a586bd', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(269, '3482a937-8236-4f1a-8324-d4bdf3a586bd', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(270, '3482a937-8236-4f1a-8324-d4bdf3a586bd', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(271, '37ee1424-fb4c-4244-a63c-82f393412070', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(272, '37ee1424-fb4c-4244-a63c-82f393412070', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(273, '37ee1424-fb4c-4244-a63c-82f393412070', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(274, '37ee1424-fb4c-4244-a63c-82f393412070', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(275, '5ccf036e-2aaa-45b5-a515-40eaef98f7aa', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(276, '5ccf036e-2aaa-45b5-a515-40eaef98f7aa', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(277, '5ccf036e-2aaa-45b5-a515-40eaef98f7aa', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(278, '5ccf036e-2aaa-45b5-a515-40eaef98f7aa', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(279, 'fafc98f3-fdfb-426d-a7ab-a1e313118495', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(280, 'fafc98f3-fdfb-426d-a7ab-a1e313118495', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(281, 'fafc98f3-fdfb-426d-a7ab-a1e313118495', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(282, 'fafc98f3-fdfb-426d-a7ab-a1e313118495', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(283, '813fb3ae-5fcf-42a6-89d4-201c4ceab96b', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(284, '813fb3ae-5fcf-42a6-89d4-201c4ceab96b', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(285, '813fb3ae-5fcf-42a6-89d4-201c4ceab96b', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(286, '813fb3ae-5fcf-42a6-89d4-201c4ceab96b', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(287, '396d561c-3302-4acf-a0f7-657eeb18dc5d', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(288, '396d561c-3302-4acf-a0f7-657eeb18dc5d', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(289, '396d561c-3302-4acf-a0f7-657eeb18dc5d', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(290, '396d561c-3302-4acf-a0f7-657eeb18dc5d', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(291, '9df88038-e823-4331-a586-f03895252e95', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(292, '9df88038-e823-4331-a586-f03895252e95', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(293, '9df88038-e823-4331-a586-f03895252e95', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(294, '9df88038-e823-4331-a586-f03895252e95', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(295, 'c9221b1a-207b-4133-a3a2-53321810b6e4', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(296, 'c9221b1a-207b-4133-a3a2-53321810b6e4', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(297, 'c9221b1a-207b-4133-a3a2-53321810b6e4', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(298, 'c9221b1a-207b-4133-a3a2-53321810b6e4', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(299, 'c2a7e086-2ae8-4d53-aa5e-2d9177e00ffb', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(300, 'c2a7e086-2ae8-4d53-aa5e-2d9177e00ffb', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(301, 'c2a7e086-2ae8-4d53-aa5e-2d9177e00ffb', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(302, 'c2a7e086-2ae8-4d53-aa5e-2d9177e00ffb', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(303, 'd7113d84-b5a5-49c3-94c8-1646a8f87227', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(304, 'd7113d84-b5a5-49c3-94c8-1646a8f87227', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(305, 'd7113d84-b5a5-49c3-94c8-1646a8f87227', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(306, 'd7113d84-b5a5-49c3-94c8-1646a8f87227', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(307, '0e814313-8eb5-4d2b-9b9f-ed85af0eca0a', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(308, '0e814313-8eb5-4d2b-9b9f-ed85af0eca0a', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(309, '0e814313-8eb5-4d2b-9b9f-ed85af0eca0a', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(310, '0e814313-8eb5-4d2b-9b9f-ed85af0eca0a', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(311, 'a4942f47-a017-4cb6-a1f9-da2e288e3c7f', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(312, 'a4942f47-a017-4cb6-a1f9-da2e288e3c7f', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(313, 'a4942f47-a017-4cb6-a1f9-da2e288e3c7f', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(314, 'a4942f47-a017-4cb6-a1f9-da2e288e3c7f', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(315, '78594988-4920-4432-a668-79f6fb40be74', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(316, '78594988-4920-4432-a668-79f6fb40be74', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(317, '78594988-4920-4432-a668-79f6fb40be74', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(318, '78594988-4920-4432-a668-79f6fb40be74', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(319, '9e0536e4-cd90-466f-b926-adc38509e5cb', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(320, '9e0536e4-cd90-466f-b926-adc38509e5cb', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(321, '9e0536e4-cd90-466f-b926-adc38509e5cb', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(322, '9e0536e4-cd90-466f-b926-adc38509e5cb', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(323, '40b600d0-46c5-46a1-b40d-ea7ad90feb19', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(324, '40b600d0-46c5-46a1-b40d-ea7ad90feb19', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(325, '40b600d0-46c5-46a1-b40d-ea7ad90feb19', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(326, '40b600d0-46c5-46a1-b40d-ea7ad90feb19', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(327, '9c45fd51-8950-4e0b-9b5a-a395cfc7fca1', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(328, '9c45fd51-8950-4e0b-9b5a-a395cfc7fca1', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(329, '9c45fd51-8950-4e0b-9b5a-a395cfc7fca1', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(330, '9c45fd51-8950-4e0b-9b5a-a395cfc7fca1', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(331, '54bf661b-5b11-4c13-95a2-bb55e3ebf96a', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(332, '54bf661b-5b11-4c13-95a2-bb55e3ebf96a', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(333, '54bf661b-5b11-4c13-95a2-bb55e3ebf96a', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(334, '54bf661b-5b11-4c13-95a2-bb55e3ebf96a', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(335, '5ef4b399-f0b3-4db3-9bd7-3aa77e759ed8', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(336, '5ef4b399-f0b3-4db3-9bd7-3aa77e759ed8', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(337, '5ef4b399-f0b3-4db3-9bd7-3aa77e759ed8', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(338, '5ef4b399-f0b3-4db3-9bd7-3aa77e759ed8', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(339, '3bafc638-52f0-4f8d-8da2-d27e53f5b699', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(340, '3bafc638-52f0-4f8d-8da2-d27e53f5b699', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(341, '3bafc638-52f0-4f8d-8da2-d27e53f5b699', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(342, '3bafc638-52f0-4f8d-8da2-d27e53f5b699', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(343, 'e49d873c-9de4-4ccd-b0fa-0e312408004e', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(344, 'e49d873c-9de4-4ccd-b0fa-0e312408004e', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(345, 'e49d873c-9de4-4ccd-b0fa-0e312408004e', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(346, 'e49d873c-9de4-4ccd-b0fa-0e312408004e', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(347, 'f5873fb8-b42b-4b88-a541-896d3fdd6d49', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(348, 'f5873fb8-b42b-4b88-a541-896d3fdd6d49', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(349, 'f5873fb8-b42b-4b88-a541-896d3fdd6d49', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(350, 'f5873fb8-b42b-4b88-a541-896d3fdd6d49', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(351, 'dbf44f72-1323-42f8-8a04-6fdf14ffe60a', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(352, 'dbf44f72-1323-42f8-8a04-6fdf14ffe60a', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(353, 'dbf44f72-1323-42f8-8a04-6fdf14ffe60a', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(354, 'dbf44f72-1323-42f8-8a04-6fdf14ffe60a', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(355, '1c9a85fb-c373-4375-9875-2341d36b0bee', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(356, '1c9a85fb-c373-4375-9875-2341d36b0bee', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(357, '1c9a85fb-c373-4375-9875-2341d36b0bee', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(358, '1c9a85fb-c373-4375-9875-2341d36b0bee', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(359, '65a3ce0d-0235-4a4c-bf53-595b1f5e3d27', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(360, '65a3ce0d-0235-4a4c-bf53-595b1f5e3d27', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(361, '65a3ce0d-0235-4a4c-bf53-595b1f5e3d27', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(362, '65a3ce0d-0235-4a4c-bf53-595b1f5e3d27', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(363, '06cba1c9-7f8d-4396-9424-915f52a43676', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(364, '06cba1c9-7f8d-4396-9424-915f52a43676', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(365, '06cba1c9-7f8d-4396-9424-915f52a43676', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(366, '06cba1c9-7f8d-4396-9424-915f52a43676', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(367, '36308a11-8bb9-4705-95e4-08cbc717e9ed', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(368, '36308a11-8bb9-4705-95e4-08cbc717e9ed', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(369, '36308a11-8bb9-4705-95e4-08cbc717e9ed', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(370, '36308a11-8bb9-4705-95e4-08cbc717e9ed', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(371, '1f6bebff-bc1b-439c-8bcb-e0575829a205', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(372, '1f6bebff-bc1b-439c-8bcb-e0575829a205', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(373, '1f6bebff-bc1b-439c-8bcb-e0575829a205', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(374, '1f6bebff-bc1b-439c-8bcb-e0575829a205', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(375, 'c9955188-2d24-454d-8318-a4ec852efaad', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(376, 'c9955188-2d24-454d-8318-a4ec852efaad', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(377, 'c9955188-2d24-454d-8318-a4ec852efaad', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(378, 'c9955188-2d24-454d-8318-a4ec852efaad', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(379, '6ee08778-9532-4cd6-a97b-6ccb1012f923', 'AttackNail', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(380, '6ee08778-9532-4cd6-a97b-6ccb1012f923', 'AttackBloodPressure', 1, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(381, '6ee08778-9532-4cd6-a97b-6ccb1012f923', 'AttackStareDown', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(382, '6ee08778-9532-4cd6-a97b-6ccb1012f923', 'AttackDeadStair', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(383, '89d39a22-a748-4962-bbb0-76d1df54f610', 'AttackServingUp', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(384, '89d39a22-a748-4962-bbb0-76d1df54f610', 'AttackHarden', 1, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(385, '89d39a22-a748-4962-bbb0-76d1df54f610', 'AttackWetTongue', 2, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(386, '89d39a22-a748-4962-bbb0-76d1df54f610', 'AttackSalivate', 3, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(387, 'd58dae98-2392-45a6-8c55-1fd9fccc7c41', 'AttackStaticShock', 0, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(388, 'd58dae98-2392-45a6-8c55-1fd9fccc7c41', 'AttackCrush', 1, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(389, 'd58dae98-2392-45a6-8c55-1fd9fccc7c41', 'AttackWall', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(390, 'd58dae98-2392-45a6-8c55-1fd9fccc7c41', 'AttackGrab', 3, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(391, '748949ea-3b4a-40d9-8832-37ca10d7bfaa', 'AttackPerchAndPoop', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(392, '748949ea-3b4a-40d9-8832-37ca10d7bfaa', 'AttackGobbleTango', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(393, '748949ea-3b4a-40d9-8832-37ca10d7bfaa', 'AttackPray', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(394, '748949ea-3b4a-40d9-8832-37ca10d7bfaa', 'AttackDefend', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(395, '212c4e8b-a328-40e3-9a36-2b9a3d4b6752', 'AttackStaticShock', 0, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(396, '212c4e8b-a328-40e3-9a36-2b9a3d4b6752', 'AttackCrush', 1, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(397, '212c4e8b-a328-40e3-9a36-2b9a3d4b6752', 'AttackWall', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(398, '212c4e8b-a328-40e3-9a36-2b9a3d4b6752', 'AttackGrab', 3, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(399, '16ccbc14-cc1b-4d8e-84d9-53e6cf21b254', 'AttackServingUp', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(400, '16ccbc14-cc1b-4d8e-84d9-53e6cf21b254', 'AttackHarden', 1, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(401, '16ccbc14-cc1b-4d8e-84d9-53e6cf21b254', 'AttackWetTongue', 2, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(402, '16ccbc14-cc1b-4d8e-84d9-53e6cf21b254', 'AttackSalivate', 3, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(403, '7bf94f68-31a7-4aec-8d28-25116e66b6ea', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(404, '7bf94f68-31a7-4aec-8d28-25116e66b6ea', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(405, '7bf94f68-31a7-4aec-8d28-25116e66b6ea', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(406, '7bf94f68-31a7-4aec-8d28-25116e66b6ea', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(407, '863a38e8-9575-47ee-8b88-bba292f168af', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(408, '863a38e8-9575-47ee-8b88-bba292f168af', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(409, '863a38e8-9575-47ee-8b88-bba292f168af', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(410, '863a38e8-9575-47ee-8b88-bba292f168af', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(411, '52132cb0-4314-4776-89a3-bfbf2f12f9b5', 'AttackServingUp', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(412, '52132cb0-4314-4776-89a3-bfbf2f12f9b5', 'AttackHarden', 1, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(413, '52132cb0-4314-4776-89a3-bfbf2f12f9b5', 'AttackWetTongue', 2, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(414, '52132cb0-4314-4776-89a3-bfbf2f12f9b5', 'AttackSalivate', 3, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(415, 'b545c98a-74eb-4d68-98fc-753e9cbc84ac', 'AttackStaticShock', 0, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(416, 'b545c98a-74eb-4d68-98fc-753e9cbc84ac', 'AttackCrush', 1, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(417, 'b545c98a-74eb-4d68-98fc-753e9cbc84ac', 'AttackWall', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(418, 'b545c98a-74eb-4d68-98fc-753e9cbc84ac', 'AttackGrab', 3, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(419, '87da3a64-4072-4de7-8a1b-04a828c32e8e', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(420, '87da3a64-4072-4de7-8a1b-04a828c32e8e', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(421, '87da3a64-4072-4de7-8a1b-04a828c32e8e', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(422, '87da3a64-4072-4de7-8a1b-04a828c32e8e', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(423, '97ed4e88-f836-4682-be05-3c20fb88ae7f', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(424, '97ed4e88-f836-4682-be05-3c20fb88ae7f', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(425, '97ed4e88-f836-4682-be05-3c20fb88ae7f', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(426, '97ed4e88-f836-4682-be05-3c20fb88ae7f', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(427, 'ea99c2b6-4d23-4be5-bcc7-b7098dd41c90', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(428, 'ea99c2b6-4d23-4be5-bcc7-b7098dd41c90', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `owned_attacks` (`id`, `owned_morty_id`, `attack_id`, `position`, `amount`, `pp`, `pp_stat`, `stat`, `type`, `to_self`, `is_accurate`, `accuracy`, `power`) VALUES
(429, 'ea99c2b6-4d23-4be5-bcc7-b7098dd41c90', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(430, 'ea99c2b6-4d23-4be5-bcc7-b7098dd41c90', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(431, '2b537789-e74b-4e96-acea-ac4718996ff1', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(432, '2b537789-e74b-4e96-acea-ac4718996ff1', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(433, '2b537789-e74b-4e96-acea-ac4718996ff1', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(434, '2b537789-e74b-4e96-acea-ac4718996ff1', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(435, 'f1dfefe5-7055-47dd-bdb5-cd2e602eac0f', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(436, 'f1dfefe5-7055-47dd-bdb5-cd2e602eac0f', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(437, 'f1dfefe5-7055-47dd-bdb5-cd2e602eac0f', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(438, 'f1dfefe5-7055-47dd-bdb5-cd2e602eac0f', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(439, '00cd2543-231b-447e-a6d9-80cfbeb93713', 'AttackServingUp', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(440, '00cd2543-231b-447e-a6d9-80cfbeb93713', 'AttackHarden', 1, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(441, '00cd2543-231b-447e-a6d9-80cfbeb93713', 'AttackWetTongue', 2, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(442, '00cd2543-231b-447e-a6d9-80cfbeb93713', 'AttackSalivate', 3, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(443, '851e01b7-0af7-43b6-8ef3-c47b46b1fd76', 'AttackStaticShock', 0, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(444, '851e01b7-0af7-43b6-8ef3-c47b46b1fd76', 'AttackCrush', 1, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(445, '851e01b7-0af7-43b6-8ef3-c47b46b1fd76', 'AttackWall', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(446, '851e01b7-0af7-43b6-8ef3-c47b46b1fd76', 'AttackGrab', 3, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(447, 'f2d51d40-86c1-4f89-aeb3-4f3d70c2cd8b', 'AttackPerchAndPoop', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(448, 'f2d51d40-86c1-4f89-aeb3-4f3d70c2cd8b', 'AttackGobbleTango', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(449, 'f2d51d40-86c1-4f89-aeb3-4f3d70c2cd8b', 'AttackPray', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(450, 'f2d51d40-86c1-4f89-aeb3-4f3d70c2cd8b', 'AttackDefend', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(451, '32ad1102-68c4-4d1a-8643-d5548ae63fe8', 'AttackStaticShock', 0, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(452, '32ad1102-68c4-4d1a-8643-d5548ae63fe8', 'AttackCrush', 1, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(453, '32ad1102-68c4-4d1a-8643-d5548ae63fe8', 'AttackWall', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(454, '32ad1102-68c4-4d1a-8643-d5548ae63fe8', 'AttackGrab', 3, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(455, '933aa2c0-faf4-47f7-baee-6301037881f3', 'AttackPerchAndPoop', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(456, '933aa2c0-faf4-47f7-baee-6301037881f3', 'AttackGobbleTango', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(457, '933aa2c0-faf4-47f7-baee-6301037881f3', 'AttackPray', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(458, '933aa2c0-faf4-47f7-baee-6301037881f3', 'AttackDefend', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(459, 'b9a1e8a6-e704-4cca-8159-bc0a8ddaf979', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(460, 'b9a1e8a6-e704-4cca-8159-bc0a8ddaf979', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(461, 'b9a1e8a6-e704-4cca-8159-bc0a8ddaf979', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(462, 'b9a1e8a6-e704-4cca-8159-bc0a8ddaf979', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(463, 'e40726cf-1dad-4a3c-af09-3e514380d5d4', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(464, 'e40726cf-1dad-4a3c-af09-3e514380d5d4', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(465, 'e40726cf-1dad-4a3c-af09-3e514380d5d4', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(466, 'e40726cf-1dad-4a3c-af09-3e514380d5d4', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(467, '195bdecf-ec18-44db-8eb0-18717fa7ca5d', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(468, '195bdecf-ec18-44db-8eb0-18717fa7ca5d', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(469, '195bdecf-ec18-44db-8eb0-18717fa7ca5d', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(470, '195bdecf-ec18-44db-8eb0-18717fa7ca5d', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(471, '0109a7b6-4c21-474d-bef7-755097d67170', 'AttackStaticShock', 0, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(472, '0109a7b6-4c21-474d-bef7-755097d67170', 'AttackCrush', 1, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(473, '0109a7b6-4c21-474d-bef7-755097d67170', 'AttackWall', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(474, '0109a7b6-4c21-474d-bef7-755097d67170', 'AttackGrab', 3, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(475, 'f4d55c64-e3eb-4495-801f-b49cf2c62c49', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(476, 'f4d55c64-e3eb-4495-801f-b49cf2c62c49', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(477, 'f4d55c64-e3eb-4495-801f-b49cf2c62c49', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(478, 'f4d55c64-e3eb-4495-801f-b49cf2c62c49', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(479, 'ed268e48-7f01-445a-baeb-912b970f262a', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(480, 'ed268e48-7f01-445a-baeb-912b970f262a', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(481, 'ed268e48-7f01-445a-baeb-912b970f262a', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(482, 'ed268e48-7f01-445a-baeb-912b970f262a', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(483, '71024ca5-1304-4a59-b69a-0a38b9a06460', 'AttackServingUp', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(484, '71024ca5-1304-4a59-b69a-0a38b9a06460', 'AttackHarden', 1, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(485, '71024ca5-1304-4a59-b69a-0a38b9a06460', 'AttackWetTongue', 2, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(486, '71024ca5-1304-4a59-b69a-0a38b9a06460', 'AttackSalivate', 3, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(487, '41d4ea39-6c79-47d6-a64d-fb94f916737c', 'AttackOutburst', 0, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(488, '44388862-6322-4e33-b816-0ccee32b9d42', 'AttackPerchAndPoop', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(489, '44388862-6322-4e33-b816-0ccee32b9d42', 'AttackGobbleTango', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(490, '44388862-6322-4e33-b816-0ccee32b9d42', 'AttackPray', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(491, '44388862-6322-4e33-b816-0ccee32b9d42', 'AttackDefend', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(492, 'a5f14b62-cb7d-4f38-8e99-875ccac399ae', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(493, 'a5f14b62-cb7d-4f38-8e99-875ccac399ae', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(494, 'a5f14b62-cb7d-4f38-8e99-875ccac399ae', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(495, 'a5f14b62-cb7d-4f38-8e99-875ccac399ae', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(496, 'f12a5067-f2d1-4e8f-9b92-367617b1df52', 'AttackPerchAndPoop', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(497, 'f12a5067-f2d1-4e8f-9b92-367617b1df52', 'AttackGobbleTango', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(498, 'f12a5067-f2d1-4e8f-9b92-367617b1df52', 'AttackPray', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(499, 'f12a5067-f2d1-4e8f-9b92-367617b1df52', 'AttackDefend', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(500, 'ed22d38b-b7de-4e36-bca1-6552ae7bde8e', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(501, 'ed22d38b-b7de-4e36-bca1-6552ae7bde8e', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(502, 'ed22d38b-b7de-4e36-bca1-6552ae7bde8e', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(503, 'ed22d38b-b7de-4e36-bca1-6552ae7bde8e', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(504, '69bddc54-0213-4ddb-97b5-8cf88ffc6ab5', 'AttackLaserStare', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(505, '69bddc54-0213-4ddb-97b5-8cf88ffc6ab5', 'AttackDinnerTime', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(506, '69bddc54-0213-4ddb-97b5-8cf88ffc6ab5', 'AttackFlutter', 2, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(507, '69bddc54-0213-4ddb-97b5-8cf88ffc6ab5', 'AttackBlink', 3, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(508, '83b6b02c-f189-4de5-a68f-ae88f5b52596', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(509, '83b6b02c-f189-4de5-a68f-ae88f5b52596', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(510, '83b6b02c-f189-4de5-a68f-ae88f5b52596', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(511, '83b6b02c-f189-4de5-a68f-ae88f5b52596', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(512, '50db7a42-13f9-41d5-96d5-51cc4e8312af', 'AttackServingUp', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(513, '50db7a42-13f9-41d5-96d5-51cc4e8312af', 'AttackHarden', 1, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(514, '50db7a42-13f9-41d5-96d5-51cc4e8312af', 'AttackWetTongue', 2, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(515, '50db7a42-13f9-41d5-96d5-51cc4e8312af', 'AttackSalivate', 3, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(516, '3815c502-6885-4f3d-ac9f-ae605ea037f1', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(517, '3815c502-6885-4f3d-ac9f-ae605ea037f1', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(518, '3815c502-6885-4f3d-ac9f-ae605ea037f1', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(519, '3815c502-6885-4f3d-ac9f-ae605ea037f1', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(520, 'f1e74a5e-0bdc-4332-a696-c2946c1d7073', 'AttackStaticShock', 0, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(521, 'f1e74a5e-0bdc-4332-a696-c2946c1d7073', 'AttackCrush', 1, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(522, 'f1e74a5e-0bdc-4332-a696-c2946c1d7073', 'AttackWall', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(523, 'f1e74a5e-0bdc-4332-a696-c2946c1d7073', 'AttackGrab', 3, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(524, '86580464-b547-4e3a-97d3-912976262744', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(525, '86580464-b547-4e3a-97d3-912976262744', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(526, '86580464-b547-4e3a-97d3-912976262744', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(527, '86580464-b547-4e3a-97d3-912976262744', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(528, 'dadbf85c-05b8-4bd9-936c-1491ac6516e1', 'AttackSparkle', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(529, 'dadbf85c-05b8-4bd9-936c-1491ac6516e1', 'AttackArtsyFartsy', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(530, 'dadbf85c-05b8-4bd9-936c-1491ac6516e1', 'AttackStarGaze', 2, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(531, 'dadbf85c-05b8-4bd9-936c-1491ac6516e1', 'AttackUpbeat', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(532, '8717c33a-9215-4079-80a8-d3c22a26d0cc', 'AttackPerchAndPoop', 0, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(533, '8717c33a-9215-4079-80a8-d3c22a26d0cc', 'AttackGobbleTango', 1, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(534, '8717c33a-9215-4079-80a8-d3c22a26d0cc', 'AttackPray', 2, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(535, '8717c33a-9215-4079-80a8-d3c22a26d0cc', 'AttackDefend', 3, NULL, 10, 10, NULL, NULL, NULL, NULL, NULL, NULL),
(536, '28f21cbb-46d5-4c98-b0e3-0650b209f1a8', 'AttackServingUp', 0, NULL, 8, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(537, '28f21cbb-46d5-4c98-b0e3-0650b209f1a8', 'AttackHarden', 1, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(538, '28f21cbb-46d5-4c98-b0e3-0650b209f1a8', 'AttackWetTongue', 2, NULL, 5, 5, NULL, NULL, NULL, NULL, NULL, NULL),
(539, '28f21cbb-46d5-4c98-b0e3-0650b209f1a8', 'AttackSalivate', 3, NULL, 15, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(540, '43c6a8d9-fbfa-4378-b477-b51664408358', 'AttackOutburst', 0, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL),
(541, 'db3f0f93-27fb-4b51-be50-7f2ad7eaff71', 'AttackOutburst', 0, NULL, 12, 12, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `owned_avatars`
--

CREATE TABLE `owned_avatars` (
  `id` int(11) NOT NULL,
  `player_id` text DEFAULT NULL,
  `player_avatar_id` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `owned_avatars`
--

INSERT INTO `owned_avatars` (`id`, `player_id`, `player_avatar_id`) VALUES
(1, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '[\"AvatarRickDefault\",\"AvatarBugAnne\",\"AvatarMortyJr\",\"AvatarRickEvil\"]'),
(2, '38d582e2-8942-4110-8144-6d959649c17b', '[\"AvatarRickDefault\"]'),
(3, '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', '[\"AvatarRickDefault\"]'),
(4, '2e5b5204-defe-42ed-a111-9cf31e985a2f', '[\"AvatarRickDefault\",\"AvatarDrXenonBloom\"]'),
(5, '7ac2cc37-441d-4007-b678-ff13ce2280c2', '[\"AvatarRickDefault\"]');

-- --------------------------------------------------------

--
-- Table structure for table `owned_items`
--

CREATE TABLE `owned_items` (
  `id` int(11) NOT NULL,
  `player_id` text DEFAULT NULL,
  `item_id` text DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `owned_items`
--

INSERT INTO `owned_items` (`id`, `player_id`, `item_id`, `quantity`) VALUES
(1, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemMortyChip', 8),
(2, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemSerum', 8),
(3, '38d582e2-8942-4110-8144-6d959649c17b', 'ItemMortyChip', 1),
(4, '38d582e2-8942-4110-8144-6d959649c17b', 'ItemSerum', 1),
(5, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemMrMeeseek', 10),
(6, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemMegaSeedLevelUp', 10),
(7, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemMegaSeedDefence', 10),
(8, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemMegaSeedSpeed', 10),
(9, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemFullRecover', 10),
(10, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemPureSerum', 9),
(11, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemPureHalzinger', 3),
(12, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemMegaSeedAttack', 10),
(13, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemHalzinger', 5),
(14, '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', 'ItemMortyChip', 1),
(15, '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', 'ItemSerum', 1),
(16, '2e5b5204-defe-42ed-a111-9cf31e985a2f', 'ItemMortyChip', 1),
(17, '2e5b5204-defe-42ed-a111-9cf31e985a2f', 'ItemSerum', 1),
(18, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemTinCan', 5),
(19, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemCircuitBoard', 10),
(20, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemPlutonicRock', 10),
(21, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemCable', 10),
(22, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemPoisonCure', 10),
(23, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemBacteriaCell', 10),
(24, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ItemDarkEnergyBall', 2),
(25, '7ac2cc37-441d-4007-b678-ff13ce2280c2', 'ItemMortyChip', 1),
(26, '7ac2cc37-441d-4007-b678-ff13ce2280c2', 'ItemSerum', 1);

-- --------------------------------------------------------

--
-- Table structure for table `owned_morties`
--

CREATE TABLE `owned_morties` (
  `id` int(11) NOT NULL,
  `player_id` text DEFAULT NULL,
  `owned_morty_id` text DEFAULT NULL,
  `morty_id` text DEFAULT NULL,
  `level` bigint(100) DEFAULT NULL,
  `xp` bigint(255) DEFAULT NULL,
  `hp` bigint(255) DEFAULT NULL,
  `hp_stat` bigint(255) DEFAULT NULL,
  `attack_stat` bigint(255) DEFAULT NULL,
  `defence_stat` bigint(255) DEFAULT NULL,
  `variant` text DEFAULT NULL,
  `speed_stat` bigint(255) DEFAULT NULL,
  `is_locked` varchar(255) DEFAULT NULL,
  `is_trading_locked` varchar(255) DEFAULT NULL,
  `fight_pit_id` varchar(255) DEFAULT NULL,
  `evolution_points` bigint(255) DEFAULT NULL,
  `xp_lower` bigint(255) DEFAULT NULL,
  `xp_upper` bigint(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `owned_morties`
--

INSERT INTO `owned_morties` (`id`, `player_id`, `owned_morty_id`, `morty_id`, `level`, `xp`, `hp`, `hp_stat`, `attack_stat`, `defence_stat`, `variant`, `speed_stat`, `is_locked`, `is_trading_locked`, `fight_pit_id`, `evolution_points`, `xp_lower`, `xp_upper`, `created_at`) VALUES
(1, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'a3e20258-48f8-4602-af17-ad0348c2fbcb', 'MortyDefault', 5, 125, 20, 20, 11, 10, 'Normal', 10, 'false', 'false', 'null', 0, 125, 216, '2026-02-03 18:35:46'),
(2, '38d582e2-8942-4110-8144-6d959649c17b', '49b46dfa-1e78-4773-b772-89ac459109b8', 'MortyDefault', 5, 125, 20, 20, 11, 10, 'Normal', 10, 'false', 'false', 'null', 0, 125, 216, '2026-02-03 18:35:46'),
(3, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '7b3e9d2a-4c61-4f8a-b5e7-1a6d9c2f3e80', 'MortyMiami', 5, 125, 20, 20, 11, 10, 'Shiny', 10, 'false', 'false', 'null', 0, 125, 216, '2026-02-04 15:41:07'),
(4, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '71bcabdb-7477-46bd-9c19-9ddba76f1150', 'MortyRobotChicken', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 19:39:01'),
(5, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '6f8b2b8f-3215-4e15-8632-447208b4914b', 'MortyCrow', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 19:39:02'),
(6, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ead22445-fdff-44ea-8a13-933db5d1f4c0', 'MortyRobotChicken', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 19:39:03'),
(7, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '2dabef00-24d4-40ae-9ff8-d1c93cdd1146', 'MortyCrow', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 19:39:34'),
(8, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '2a004853-b0f4-4bac-8896-16a80e2c34b2', 'MortyMulti', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 19:39:34'),
(9, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '03986945-f571-40ea-a06f-3ef49074b9e8', 'MortyMulti', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 19:39:35'),
(10, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '26190714-3b6e-4191-95d9-7f6686be9474', 'MortyExoPrime', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 19:39:46'),
(11, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '52550f1f-b20b-4d89-aaee-ebae2e1f0452', 'MortyCrying', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 19:39:46'),
(12, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'd3990041-d3c0-4153-8915-1e2a10728a88', 'MortyPrisoner', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 19:39:47'),
(13, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '89dafefa-6075-4076-8b9b-78b3b21c1b71', 'MortyRobotChicken', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 19:42:26'),
(14, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '2e3bc859-b1ca-4e15-98ed-d9c13f86e77e', 'MortyCrying', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 19:42:27'),
(15, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '88c73396-2b61-4edb-aa6e-cbac6409a6e0', 'MortyRobotChicken', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 19:42:28'),
(16, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'd893c384-33a2-4966-9848-365068a6251c', 'MortySoldadoLoco', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 19:42:42'),
(17, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '3fcfd114-b6e6-4851-bc0d-48b866fe5b44', 'MortyMulti', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 19:42:42'),
(18, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '58f8572d-04f3-4820-88e5-3b37ca96c828', 'MortyCrying', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 19:42:43'),
(19, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'b5cef065-9547-42bf-81a9-baf3c6afeab2', 'MortyPrisoner', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:27:11'),
(20, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'aca7b066-98a4-4943-ab72-010948a37f7b', 'MortyTeaCup', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:27:11'),
(21, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '40d0b542-c38a-4030-b612-ba4f893f32f8', 'MortyCrying', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:27:12'),
(22, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f9d3c8f9-cfd4-45df-94da-abda611bb540', 'MortyFelon', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:27:12'),
(23, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '22d64b02-b257-4bcf-b1a4-71cce452c3f3', 'MortyPrisoner', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:27:13'),
(24, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'edc89405-cfab-42d8-a569-a78444795bfd', 'MortyCrow', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:27:13'),
(25, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '40dec3d6-97fc-4d41-8d31-cae0648b8547', 'MortyRobotChicken', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:27:31'),
(26, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '93c9f392-b917-4443-9d6a-f2732cbb8668', 'MortyPrisoner', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:32'),
(27, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '8a26b551-fcc8-4c38-b106-724b2fcb09dd', 'MortyExoPrime', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:32'),
(28, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '414f7c1c-2eac-4787-92c7-ada880e15e17', 'MortyMulti', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:33'),
(29, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ad141b79-6a55-4468-a006-51ee988c9f3a', 'MortyFelon', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:33'),
(30, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '3b9ed302-36c7-46a4-b49b-cd677df9a6fc', 'MortySoldadoLoco', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:27:34'),
(31, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '289ca58e-a886-47b9-95be-82f955921202', 'MortySoldadoLoco', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:46'),
(32, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'b79e5838-b0f1-4dea-9455-4e983784a246', 'MortyExoPrime', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:27:47'),
(33, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'a13e1bff-2ba9-4472-85e3-e8eaffd575f7', 'MortyCrow', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:27:47'),
(34, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '27751068-2269-4b09-9671-c3e4ea5c950e', 'MortySoldadoLoco', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:48'),
(35, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '570ef060-ea81-4fff-a42f-32443a2c9b1c', 'MortyRobotChicken', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:48'),
(36, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'aa764c3b-e7cc-499b-a7aa-5eb14ee7bc13', 'MortyFelon', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:27:49'),
(37, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '15a1e146-0c73-4d3c-b5f4-e2d77c387ac0', 'MortyFelon', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:28:32'),
(38, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ab247161-da2e-4f10-9ada-a7bdc9b68507', 'MortyMulti', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:28:32'),
(39, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '8f12a1ae-82f8-446a-8fe7-89dd5a9da958', 'MortyPrisoner', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:28:33'),
(40, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'dc97a146-14ad-45de-851c-24533d5c895a', 'MortyCrow', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:28:33'),
(41, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '047d1551-12c7-4e6e-8e34-e7e3e317dd34', 'MortyCrow', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:28:34'),
(42, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '44b83c78-921a-4226-90ca-42d26e50a82a', 'MortyCrow', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:28:34'),
(43, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '05d16496-4dcb-469e-9cea-8a5c058c48f6', 'MortyPrisoner', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:32:09'),
(44, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'af079653-3ffb-4a40-8c86-3d1de952f8c3', 'MortySoldadoLoco', 29, 23548, 79, 79, 51, 51, 'Normal', 51, 'false', 'false', 'null', 0, 23548, 23548, '2026-02-05 20:32:10'),
(45, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '04d58042-9dd6-4d2c-afdc-bdf307ef32b9', 'MortyMulti', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:32:10'),
(46, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f926169c-5902-46f1-9404-f25379b66a09', 'MortyPrisoner', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:32:11'),
(47, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '34c9bb9c-ada1-497d-a7a7-59aa8361fc54', 'MortySoldadoLoco', 28, 21952, 78, 78, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 21952, 21952, '2026-02-05 20:32:12'),
(48, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'aad4a06f-c1ca-4c96-9e8b-ef1c2abbc039', 'MortyExoPrime', 27, 20412, 77, 77, 50, 50, 'Normal', 50, 'false', 'false', 'null', 0, 20412, 20412, '2026-02-05 20:32:12'),
(49, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '19bf7c0a-17b5-4819-a110-d1dfa1a3411e', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:13:47'),
(50, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '85935091-4c8b-4de8-aa05-8c6255bdeb49', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:13:48'),
(51, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '64d6a054-2ada-40d1-9f8f-623e2d433b3e', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:13:49'),
(52, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '392ad226-786d-47e7-b032-6603bde53d84', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:14:09'),
(53, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'd4f4a9e8-539e-4d2f-8fb2-c57ba07055fe', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:09'),
(54, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '7731f95e-1bd8-4075-a977-eafe1bb78b6b', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:10'),
(55, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ae627f4a-6729-4e25-8a2c-449cb39b2010', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:10'),
(56, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '66097460-3c3c-4a24-956e-67e097ef00a1', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:11'),
(57, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'e9c6b9c0-fb54-4b3a-bb0b-4afe6b799332', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:12'),
(58, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'e3262a5f-634d-42bd-a9b0-4b74d418c898', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:14:12'),
(59, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'bc4570e8-5030-49e2-bd70-9c6f6c87d239', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:30'),
(60, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '77e64578-b882-4b6e-8e3f-ada448d585f0', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:31'),
(61, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '95d39a19-07f2-4e68-b766-2360aa476426', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:31'),
(62, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'c95e71ae-7c6f-4710-a51c-07e7833a563d', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:32'),
(63, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'e23e698f-7061-4edf-b36c-209b5712b717', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:33'),
(64, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '77215d16-eecd-48c9-9560-1889381848e9', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:34'),
(65, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '1e0b1d8e-50e3-4e62-a85c-af3a4ea59e18', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:34'),
(66, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'd11c07cb-98a9-45da-bdcf-90c8ddebeab1', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:50'),
(67, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'd7328f39-e8a5-4335-9da3-2b639257abc1', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:14:51'),
(68, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'b71cd49f-ac73-40f8-9db6-5fd8cbefdbec', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:51'),
(69, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '16787d00-674f-43f5-ac4b-b16c7a29499b', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:14:52'),
(70, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '3482a937-8236-4f1a-8324-d4bdf3a586bd', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:52'),
(71, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '37ee1424-fb4c-4244-a63c-82f393412070', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:14:53'),
(72, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '5ccf036e-2aaa-45b5-a515-40eaef98f7aa', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:14:53'),
(73, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'fafc98f3-fdfb-426d-a7ab-a1e313118495', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:54'),
(74, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '813fb3ae-5fcf-42a6-89d4-201c4ceab96b', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:54'),
(75, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '396d561c-3302-4acf-a0f7-657eeb18dc5d', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:14:55'),
(76, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '9df88038-e823-4331-a586-f03895252e95', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:55:18'),
(77, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'c9221b1a-207b-4133-a3a2-53321810b6e4', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:55:19'),
(78, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'c2a7e086-2ae8-4d53-aa5e-2d9177e00ffb', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:55:19'),
(79, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'd7113d84-b5a5-49c3-94c8-1646a8f87227', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:55:20'),
(80, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '0e814313-8eb5-4d2b-9b9f-ed85af0eca0a', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:55:20'),
(81, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'a4942f47-a017-4cb6-a1f9-da2e288e3c7f', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:55:21'),
(82, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '78594988-4920-4432-a668-79f6fb40be74', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:55:21'),
(83, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '9e0536e4-cd90-466f-b926-adc38509e5cb', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:55:22'),
(84, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '40b600d0-46c5-46a1-b40d-ea7ad90feb19', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:55:22'),
(85, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '9c45fd51-8950-4e0b-9b5a-a395cfc7fca1', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:55:23'),
(86, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '54bf661b-5b11-4c13-95a2-bb55e3ebf96a', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:58:00'),
(87, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '5ef4b399-f0b3-4db3-9bd7-3aa77e759ed8', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:58:01'),
(88, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '3bafc638-52f0-4f8d-8da2-d27e53f5b699', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:58:01'),
(89, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'e49d873c-9de4-4ccd-b0fa-0e312408004e', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:58:02'),
(90, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f5873fb8-b42b-4b88-a541-896d3fdd6d49', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:58:02'),
(91, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'dbf44f72-1323-42f8-8a04-6fdf14ffe60a', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:58:03'),
(92, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '1c9a85fb-c373-4375-9875-2341d36b0bee', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:58:03'),
(93, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '65a3ce0d-0235-4a4c-bf53-595b1f5e3d27', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 21:58:04'),
(94, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '06cba1c9-7f8d-4396-9424-915f52a43676', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 21:58:04'),
(95, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '36308a11-8bb9-4705-95e4-08cbc717e9ed', 'MortyRobotChicken', 33, 30492, 84, 84, 54, 54, 'Normal', 54, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 21:58:05'),
(96, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '1f6bebff-bc1b-439c-8bcb-e0575829a205', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:08:48'),
(97, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'c9955188-2d24-454d-8318-a4ec852efaad', 'MortyRobotChicken', 34, 32368, 85, 85, 55, 55, 'Normal', 55, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:08:49'),
(98, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '6ee08778-9532-4cd6-a97b-6ccb1012f923', 'MortyRobotChicken', 32, 28672, 83, 83, 53, 53, 'Normal', 53, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:08:50'),
(99, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '89d39a22-a748-4962-bbb0-76d1df54f610', 'MortyChick', 34, 32368, 117, 117, 72, 70, 'Normal', 72, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:40:43'),
(100, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'd58dae98-2392-45a6-8c55-1fd9fccc7c41', 'MortyDrone', 32, 28672, 115, 115, 83, 77, 'Normal', 83, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:40:43'),
(101, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '748949ea-3b4a-40d9-8832-37ca10d7bfaa', 'MortyTurkerSoldier', 34, 32368, 98, 98, 55, 61, 'Normal', 58, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:40:44'),
(102, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '212c4e8b-a328-40e3-9a36-2b9a3d4b6752', 'MortyDrone', 34, 32368, 118, 118, 82, 69, 'Normal', 72, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:40:45'),
(103, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '16ccbc14-cc1b-4d8e-84d9-53e6cf21b254', 'MortyChick', 32, 28672, 118, 118, 71, 68, 'Normal', 74, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:40:45'),
(104, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '7bf94f68-31a7-4aec-8d28-25116e66b6ea', 'MortyRobotChicken', 32, 28672, 115, 115, 54, 67, 'Normal', 87, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:40:46'),
(105, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '863a38e8-9575-47ee-8b88-bba292f168af', 'MortyBirdingMan', 33, 30492, 99, 99, 60, 72, 'Normal', 55, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 22:40:47'),
(106, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '52132cb0-4314-4776-89a3-bfbf2f12f9b5', 'MortyChick', 32, 28672, 111, 111, 69, 70, 'Normal', 69, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:40:47'),
(107, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'b545c98a-74eb-4d68-98fc-753e9cbc84ac', 'MortyDrone', 33, 30492, 122, 122, 74, 82, 'Normal', 79, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 22:40:48'),
(108, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '87da3a64-4072-4de7-8a1b-04a828c32e8e', 'MortyBirdingMan', 32, 28672, 100, 100, 51, 60, 'Normal', 56, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:40:48'),
(109, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '97ed4e88-f836-4682-be05-3c20fb88ae7f', 'MortyBirdingMan', 34, 32368, 98, 98, 59, 71, 'Normal', 56, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:41:15'),
(110, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ea99c2b6-4d23-4be5-bcc7-b7098dd41c90', 'MortyRobotChicken', 34, 32368, 106, 106, 63, 67, 'Normal', 76, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:41:16'),
(111, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '2b537789-e74b-4e96-acea-ac4718996ff1', 'MortyBirdingMan', 34, 32368, 92, 92, 53, 68, 'Normal', 58, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-05 22:41:17'),
(112, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f1dfefe5-7055-47dd-bdb5-cd2e602eac0f', 'MortyRobotChicken', 32, 28672, 117, 117, 62, 68, 'Normal', 80, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:41:31'),
(113, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '00cd2543-231b-447e-a6d9-80cfbeb93713', 'MortyChick', 32, 28672, 111, 111, 71, 77, 'Normal', 73, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-05 22:41:32'),
(114, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '851e01b7-0af7-43b6-8ef3-c47b46b1fd76', 'MortyDrone', 33, 30492, 115, 115, 83, 83, 'Normal', 79, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-05 22:41:33'),
(115, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f2d51d40-86c1-4f89-aeb3-4f3d70c2cd8b', 'MortyTurkerSoldier', 33, 30492, 105, 105, 57, 52, 'Normal', 63, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-06 00:13:03'),
(116, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '32ad1102-68c4-4d1a-8643-d5548ae63fe8', 'MortyDrone', 32, 28672, 122, 122, 72, 79, 'Normal', 78, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-06 00:13:03'),
(117, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '933aa2c0-faf4-47f7-baee-6301037881f3', 'MortyTurkerSoldier', 34, 32368, 111, 111, 58, 55, 'Normal', 51, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-06 00:13:04'),
(118, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'b9a1e8a6-e704-4cca-8159-bc0a8ddaf979', 'MortyBirdingMan', 32, 28672, 89, 89, 53, 65, 'Normal', 59, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-06 00:13:05'),
(119, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'e40726cf-1dad-4a3c-af09-3e514380d5d4', 'MortyRobotChicken', 32, 28672, 110, 110, 62, 68, 'Normal', 81, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-06 00:13:06'),
(120, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '195bdecf-ec18-44db-8eb0-18717fa7ca5d', 'MortyBirdingMan', 34, 32368, 96, 96, 53, 67, 'Normal', 51, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-06 00:13:06'),
(121, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '0109a7b6-4c21-474d-bef7-755097d67170', 'MortyDrone', 33, 30492, 121, 121, 72, 71, 'Normal', 71, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-06 00:13:07'),
(122, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f4d55c64-e3eb-4495-801f-b49cf2c62c49', 'MortyBirdingMan', 32, 28672, 95, 95, 54, 60, 'Normal', 51, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-06 00:13:08'),
(123, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ed268e48-7f01-445a-baeb-912b970f262a', 'MortyRobotChicken', 33, 30492, 106, 106, 60, 68, 'Normal', 88, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-06 00:13:08'),
(124, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '71024ca5-1304-4a59-b69a-0a38b9a06460', 'MortyChick', 34, 32368, 116, 116, 66, 72, 'Normal', 71, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-06 00:13:09'),
(125, '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', '41d4ea39-6c79-47d6-a64d-fb94f916737c', 'MortyDefault', 5, 125, 20, 20, 11, 10, 'Normal', 10, 'false', 'false', 'null', 0, 125, 216, '2026-02-06 22:08:19'),
(126, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '44388862-6322-4e33-b816-0ccee32b9d42', 'MortyTurkerSoldier', 34, 32368, 101, 101, 58, 53, 'Normal', 56, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-07 22:59:15'),
(127, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'a5f14b62-cb7d-4f38-8e99-875ccac399ae', 'MortyRobotChicken', 34, 32368, 110, 110, 58, 73, 'Normal', 89, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-07 22:59:15'),
(128, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f12a5067-f2d1-4e8f-9b92-367617b1df52', 'MortyTurkerSoldier', 34, 32368, 104, 104, 56, 54, 'Normal', 60, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-07 22:59:15'),
(129, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ed22d38b-b7de-4e36-bca1-6552ae7bde8e', 'MortyRobotChicken', 34, 32368, 111, 111, 52, 78, 'Normal', 90, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-07 22:59:15'),
(130, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '69bddc54-0213-4ddb-97b5-8cf88ffc6ab5', 'MortyRobotChicken', 32, 28672, 111, 111, 51, 79, 'Normal', 84, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-07 22:59:15'),
(131, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '83b6b02c-f189-4de5-a68f-ae88f5b52596', 'MortyBirdingMan', 34, 32368, 98, 98, 52, 65, 'Normal', 58, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-07 22:59:15'),
(132, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '50db7a42-13f9-41d5-96d5-51cc4e8312af', 'MortyChick', 34, 32368, 109, 109, 67, 76, 'Normal', 70, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-07 22:59:15'),
(133, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '3815c502-6885-4f3d-ac9f-ae605ea037f1', 'MortyBirdingMan', 33, 30492, 88, 88, 51, 61, 'Normal', 56, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-07 22:59:15'),
(134, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'f1e74a5e-0bdc-4332-a696-c2946c1d7073', 'MortyDrone', 32, 28672, 120, 120, 79, 78, 'Normal', 82, 'false', 'false', 'null', 0, 28672, 28672, '2026-02-07 22:59:15'),
(135, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '86580464-b547-4e3a-97d3-912976262744', 'MortyBirdingMan', 34, 32368, 95, 95, 50, 68, 'Normal', 58, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-07 22:59:15'),
(136, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'dadbf85c-05b8-4bd9-936c-1491ac6516e1', 'MortyBirdingMan', 34, 32368, 91, 91, 54, 70, 'Normal', 59, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-08 15:13:34'),
(137, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '8717c33a-9215-4079-80a8-d3c22a26d0cc', 'MortyTurkerSoldier', 34, 32368, 101, 101, 56, 57, 'Normal', 52, 'false', 'false', 'null', 0, 32368, 32368, '2026-02-08 15:13:34'),
(138, 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', '28f21cbb-46d5-4c98-b0e3-0650b209f1a8', 'MortyChick', 33, 30492, 110, 110, 67, 66, 'Normal', 71, 'false', 'false', 'null', 0, 30492, 30492, '2026-02-08 15:13:34'),
(139, '2e5b5204-defe-42ed-a111-9cf31e985a2f', '43c6a8d9-fbfa-4378-b477-b51664408358', 'MortyDefault', 5, 125, 20, 20, 11, 10, 'Normal', 10, 'false', 'false', 'null', 0, 125, 216, '2026-02-08 16:07:48'),
(140, '7ac2cc37-441d-4007-b678-ff13ce2280c2', 'db3f0f93-27fb-4b51-be50-7f2ad7eaff71', 'MortyDefault', 5, 125, 20, 20, 11, 10, 'Normal', 10, 'false', 'false', 'null', 0, 125, 216, '2026-02-08 19:54:55');

-- --------------------------------------------------------

--
-- Table structure for table `registered_users`
--

CREATE TABLE `registered_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `recovery_code_hash` varchar(255) DEFAULT NULL,
  `recovery_code_created_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `registered_users`
--

INSERT INTO `registered_users` (`id`, `email`, `password_hash`, `recovery_code_hash`, `recovery_code_created_at`, `created_at`, `last_login`) VALUES
(1, 'pocketmortys@hogwartsmail.com', '$2y$10$ICYGsm4ATIaOqrfsLSSnpO/p8IXHhsBGb9BWrLXfN5nO.71GZVRRy', '$2y$10$5bb3l.esgFe/zOZ5XOOZeOnzpTvDIcKst3dBU.1fY0KqiqR2JuhLq', '2026-02-03 11:26:35', '2026-02-02 19:56:17', '2026-02-04 23:18:47');

-- --------------------------------------------------------

--
-- Table structure for table `room_ids`
--

CREATE TABLE `room_ids` (
  `id` int(11) NOT NULL,
  `room_id` text NOT NULL,
  `room_udp_host` text DEFAULT NULL,
  `room_udp_port` text DEFAULT NULL,
  `world_id` text NOT NULL,
  `zone_id` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room_ids`
--

INSERT INTO `room_ids` (`id`, `room_id`, `room_udp_host`, `room_udp_port`, `world_id`, `zone_id`) VALUES
(1, '56092cc3-d968-4d2d-8c54-98ed0817hu97', '127.0.0.1', '13001', '1', '[13-15]');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) UNSIGNED NOT NULL,
  `recovery_code_hash` varchar(255) DEFAULT NULL,
  `secret` varchar(255) NOT NULL,
  `player_id` text DEFAULT NULL,
  `username` text DEFAULT NULL,
  `player_avatar_id` text DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `xp` int(11) DEFAULT NULL,
  `streak` int(5) DEFAULT NULL,
  `coins` bigint(255) DEFAULT 0,
  `coupons` bigint(255) DEFAULT 0,
  `permits` bigint(255) DEFAULT 0,
  `wins` bigint(255) NOT NULL DEFAULT 0,
  `losses` bigint(255) NOT NULL DEFAULT 0,
  `active_deck_id` int(10) DEFAULT NULL,
  `decks_owned` int(11) DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `xp_lower` bigint(255) DEFAULT NULL,
  `xp_upper` bigint(255) DEFAULT NULL,
  `donation_request` text DEFAULT NULL,
  `room_id` text DEFAULT NULL,
  `world_id` text DEFAULT NULL,
  `zone_id` text DEFAULT NULL,
  `session_id` text DEFAULT NULL,
  `state` text DEFAULT NULL,
  `last_event_id` bigint(20) DEFAULT 0,
  `last_seen` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `recovery_code_hash`, `secret`, `player_id`, `username`, `player_avatar_id`, `level`, `xp`, `streak`, `coins`, `coupons`, `permits`, `wins`, `losses`, `active_deck_id`, `decks_owned`, `tags`, `xp_lower`, `xp_upper`, `donation_request`, `room_id`, `world_id`, `zone_id`, `session_id`, `state`, `last_event_id`, `last_seen`, `created`) VALUES
(1, '$2y$10$5bb3l.esgFe/zOZ5XOOZeOnzpTvDIcKst3dBU.1fY0KqiqR2JuhLq', '4f0b1131-08d0-449c-9f6e-c70241b8cb70', 'f8a69ceb-1ef8-4d0b-81dc-d6d59e425163', 'ConspiracyRick', 'AvatarRickEvil', 1, 27, 0, 2743, 9870, 0, 0, 0, 0, 9, '[]', 27, 64, NULL, '56092cc3-d968-4d2d-8c54-98ed0817hu97', NULL, NULL, '2a5f2c40-081f-415b-8a36-225660415252', 'WORLD', 17, '2026-02-10 01:54:16', '2026-01-30'),
(2, NULL, '75b28069-e86e-442f-9e56-bde081044cee', '38d582e2-8942-4110-8144-6d959649c17b', 'Test', 'AvatarRickDefault', 1, 27, 0, 0, 0, 0, 0, 0, 0, 3, '[]', 27, 64, NULL, '56092cc3-d968-4d2d-8c54-98ed0817hu97', NULL, NULL, '44d2d724-51f6-4914-b782-14b49ebd6b98', 'WORLD', NULL, '2026-02-08 18:47:43', '2026-02-01'),
(3, NULL, '15fdca97-f249-419f-bef3-caaad31679e4', '21c29bd6-9f1d-4e34-96b3-9c99cc3a84d7', 'AngryDoritos', 'AvatarRickDefault', 1, 27, 0, 0, 0, 0, 0, 0, 0, 3, '[]', 27, 64, NULL, '56092cc3-d968-4d2d-8c54-98ed0817hu97', NULL, NULL, '20c24d60-dd1e-403f-a8b7-c66bc6969a00', 'WORLD', NULL, '2026-02-10 01:35:20', '2026-02-06'),
(4, NULL, '48c3d988-a543-4a6a-aea7-6606b5bd3feb', '2e5b5204-defe-42ed-a111-9cf31e985a2f', 'TheShowOfVidal', 'AvatarDrXenonBloom', 1, 27, 0, 0, 0, 0, 0, 0, 0, 3, '[]', 27, 64, NULL, '56092cc3-d968-4d2d-8c54-98ed0817hu97', NULL, NULL, '0be97460-d8f5-4b38-8eff-6b2232fb9021', 'WORLD', NULL, '2026-02-08 18:47:47', '2026-02-08'),
(5, NULL, 'ff09e0b4-6913-445c-bb04-b9fac3a61f1f', '7ac2cc37-441d-4007-b678-ff13ce2280c2', 'Dyloso', 'AvatarRickDefault', 1, 27, 0, 0, 0, 0, 0, 0, 0, 3, '[]', 27, 64, NULL, '56092cc3-d968-4d2d-8c54-98ed0817hu97', NULL, NULL, '966917a8-07bb-4314-be6e-2d3dbe20e361', 'WORLD', NULL, '2026-02-08 20:35:22', '2026-02-08');

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE `user_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `token_hash` char(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ip` varchar(64) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `decks`
--
ALTER TABLE `decks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deck_config`
--
ALTER TABLE `deck_config`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `event_queue`
--
ALTER TABLE `event_queue`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`,`id`),
  ADD KEY `created_at` (`created_at`);

--
-- Indexes for table `friend_list`
--
ALTER TABLE `friend_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gachas`
--
ALTER TABLE `gachas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `gacha_id` (`gacha_id`);

--
-- Indexes for table `gacha_contents`
--
ALTER TABLE `gacha_contents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_gacha` (`gacha_id`);

--
-- Indexes for table `gacha_content_items`
--
ALTER TABLE `gacha_content_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_content` (`gacha_content_id`);

--
-- Indexes for table `gacha_drop_rates`
--
ALTER TABLE `gacha_drop_rates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gacha_promos`
--
ALTER TABLE `gacha_promos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `gacha_promo_id` (`gacha_promo_id`);

--
-- Indexes for table `gacha_promo_attack_effects`
--
ALTER TABLE `gacha_promo_attack_effects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `promo_attack_id` (`promo_attack_id`);

--
-- Indexes for table `gacha_promo_mortys`
--
ALTER TABLE `gacha_promo_mortys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_promo_morty` (`gacha_promo_id`,`morty_id`,`variant`),
  ADD KEY `idx_promo` (`gacha_promo_id`);

--
-- Indexes for table `gacha_promo_morty_attacks`
--
ALTER TABLE `gacha_promo_morty_attacks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_promo_morty` (`gacha_promo_id`,`morty_id`);

--
-- Indexes for table `mortydex`
--
ALTER TABLE `mortydex`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `owned_attacks`
--
ALTER TABLE `owned_attacks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `owned_avatars`
--
ALTER TABLE `owned_avatars`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `owned_items`
--
ALTER TABLE `owned_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `owned_morties`
--
ALTER TABLE `owned_morties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `registered_users`
--
ALTER TABLE `registered_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Indexes for table `room_ids`
--
ALTER TABLE `room_ids`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_token_hash` (`token_hash`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_expires` (`expires_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `decks`
--
ALTER TABLE `decks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `deck_config`
--
ALTER TABLE `deck_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `event_queue`
--
ALTER TABLE `event_queue`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `friend_list`
--
ALTER TABLE `friend_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `gachas`
--
ALTER TABLE `gachas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `gacha_contents`
--
ALTER TABLE `gacha_contents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `gacha_content_items`
--
ALTER TABLE `gacha_content_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `gacha_drop_rates`
--
ALTER TABLE `gacha_drop_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `gacha_promos`
--
ALTER TABLE `gacha_promos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `gacha_promo_attack_effects`
--
ALTER TABLE `gacha_promo_attack_effects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `gacha_promo_mortys`
--
ALTER TABLE `gacha_promo_mortys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `gacha_promo_morty_attacks`
--
ALTER TABLE `gacha_promo_morty_attacks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `mortydex`
--
ALTER TABLE `mortydex`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `owned_attacks`
--
ALTER TABLE `owned_attacks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=542;

--
-- AUTO_INCREMENT for table `owned_avatars`
--
ALTER TABLE `owned_avatars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `owned_items`
--
ALTER TABLE `owned_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `owned_morties`
--
ALTER TABLE `owned_morties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT for table `registered_users`
--
ALTER TABLE `registered_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `room_ids`
--
ALTER TABLE `room_ids`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_sessions`
--
ALTER TABLE `user_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `gacha_content_items`
--
ALTER TABLE `gacha_content_items`
  ADD CONSTRAINT `gacha_content_items_ibfk_1` FOREIGN KEY (`gacha_content_id`) REFERENCES `gacha_contents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `gacha_promo_attack_effects`
--
ALTER TABLE `gacha_promo_attack_effects`
  ADD CONSTRAINT `gacha_promo_attack_effects_ibfk_1` FOREIGN KEY (`promo_attack_id`) REFERENCES `gacha_promo_morty_attacks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
