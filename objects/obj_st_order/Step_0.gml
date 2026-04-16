if (obj_game.game_mode != GAME_MODE.WORLD) exit;

if (place_meeting(x, y, obj_player)) {

    if (keyboard_check_pressed(ord("E"))) {

		var c = obj_game.customers.get_active_customer();

		if (c == noone) {
		    show_debug_message("NO CUSTOMER READY");
		    exit;
		}

		if (obj_game.customers.start_interaction(c)) {

		    obj_game.request_open_station(STATION.ORDER);

			var ui = instance_create_layer(0, 0, "UI", obj_ui_order);

			ui.customer = c;
			ui.dialog_lines = c.dialog_lines;
			ui.dialog_index = 0;
			ui.dialog_done = false;
			
		}
    }
}