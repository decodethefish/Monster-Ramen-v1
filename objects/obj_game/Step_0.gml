// Controles Tiempo
var dt = delta_time / 1000000;
dt *= time_scale_global;

// Cocción broth
broth.update();

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