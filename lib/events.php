<?php
// lib/events.php

function publish_event(PDO $pdo, string $room_id, string $event, array $payload): void {
    $pickup_id = null;
    if (isset($payload["pickup_id"]) && is_string($payload["pickup_id"]) && strlen($payload["pickup_id"]) === 36) {
        $pickup_id = $payload["pickup_id"];
    }

    $stmt = $pdo->prepare("
        INSERT INTO event_queue (room_id, event_name, payload_json, pickup_id)
        VALUES (?, ?, ?, ?)
    ");
    $stmt->execute([
        $room_id,
        $event,
        json_encode($payload, JSON_UNESCAPED_SLASHES),
        $pickup_id
    ]);
}

/**
 * sse_send("event", "{json}") works
 * sse_send("event", "{json}", 123) adds id: 123 so reconnect works
 */
function sse_send(string $event, string $dataJson, ?int $id = null): void {
    if ($id !== null) {
        echo "id: {$id}\n";
    }
    echo "event: {$event}\n";
    echo "data: {$dataJson}\n\n";
    @ob_flush();
    @flush();
}
