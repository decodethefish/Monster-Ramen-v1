// Controles Tiempo
var dt = delta_time / 1000000;
dt *= time_scale_global;


// Cocinando Sopa
for (var i = 0; i < array_length(pots); i++) {
	
	var pot = pots[i];
		
	if (pot.is_on == true && pot.broth_id != BROTH_ID.NONE) {
		
		pot.progress += dt;
		
		var data = broth_data[pot.broth_id];
		
		if (pot.progress >= data.burn_time) {
		if (pot.state != POT_STATE.BURNED) {
				pot.state = POT_STATE.BURNED;
				pot.is_on = false;
				show_debug_message("the broth is now BURNED");
			}
		}
		else if (pot.progress >= data.ready_time) {
			if (pot.state != POT_STATE.READY) {
				pot.state = POT_STATE.READY;
				show_debug_message("the broth is now READY");
				}
			}
		}
	
	pots[i] = pot;
}


// Controles UI
if (game_mode == GAME_MODE.COOKING) {
	if (!instance_exists(current_ui)) {
		
		switch(current_station) {
			
			case "station_soup":
				current_ui = instance_create_layer(0,0,"UI",obj_ui_broth);
			break;
			
			case "station_noodle":
				current_ui = instance_create_layer(0,0,"UI",obj_ui_noodles);
			break;	
		}
	}
		
		
	
	// salir de la UI.
	if keyboard_check_pressed(vk_escape) {
		
		current_station = noone;
		game_mode = GAME_MODE.WORLD;
		show_debug_message("game mode is now set to WORLD");
	}
}
	


// Regresar a World
if (game_mode == GAME_MODE.WORLD) {
	
	if (instance_exists(current_ui)) {
		
		current_ui = instance_destroy(current_ui);
		current_ui = noone;
	}
}