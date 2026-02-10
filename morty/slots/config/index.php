<?php
header("Content-Type: application/json; charset=utf-8");
header("X-Powered-By: Express");
header("Access-Control-Allow-Origin: *");
header("Vary: Accept-Encoding");

echo '{
	"config_data": {
		"config_id": "MP",
		"starting_morty_slots": 200,
		"max_morty_slots": 1000,
		"increment_slot_count": 50,
		"cost_additional_slot": 5
	}
}';

/*
echo '{
	"config_data": {
		"config_id": "MP",
		"starting_morty_slots": 350,
		"max_morty_slots": 750,
		"increment_slot_count": 100,
		"cost_additional_slot": 5
	}
}';
*/