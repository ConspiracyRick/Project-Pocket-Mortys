<?php
// lib/events.php

function publish_event(PDO $pdo, string $room_id, string $event, array $payload, ?string $player_id = null): void {
    $pickup_id = null;

    // pickup id (optional)
    if (!empty($payload["pickup_id"]) && is_string($payload["pickup_id"]) && strlen($payload["pickup_id"]) === 36) {
        $pickup_id = $payload["pickup_id"];
    }

    // battle events are player-only
    $is_battle = (strncmp($event, "battle:", 7) === 0);

    if ($is_battle) {
        // If caller didn’t pass it, try to extract from payload
        if (($player_id === null || $player_id === "") &&
            !empty($payload["player"]["player_id"]) &&
            is_string($payload["player"]["player_id"])) {
            $player_id = $payload["player"]["player_id"];
        }

        // final validation
        if (!is_string($player_id) || strlen($player_id) !== 36) {
            $player_id = null; // keep DB clean if bad/missing
        }
    } else {
        // non-battle events must be global
        $player_id = null;
    }

    $stmt = $pdo->prepare("
        INSERT INTO event_queue (room_id, event_name, payload_json, pickup_id, player_id)
        VALUES (?, ?, ?, ?, ?)
    ");
    $stmt->execute([
        $room_id,
        $event,
        json_encode($payload, JSON_UNESCAPED_SLASHES),
        $pickup_id,
        $player_id
    ]);
}

/**
 * sse_send("event", "{json}") works
 * sse_send("event", "{json}", 123) adds id: 123 so reconnect works
 */
function sse_send(string $event, string $dataJson, ?int $id = null): void {
    //if ($id !== null) { echo "id: {$id}\n"; }
    echo "event: {$event}\n";
    echo "data: {$dataJson}\n\n";
    @ob_flush();
    @flush();
}
