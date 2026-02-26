if (place_meeting(x,y,obj_player)) {
	if (keyboard_check_pressed(ord("E"))) {
		if instance_exists(obj_game) {
			obj_game.request_open_station(STATION.BROTH);
		}
	}
}

