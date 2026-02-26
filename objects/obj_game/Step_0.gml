// Controles Tiempo
var dt = delta_time / 1000000;
dt *= time_scale_global;

// updates de sistemas
broth.update();
noodles.update(dt)

// Controles UI
if (game_mode == GAME_MODE.COOKING) {
	if (!instance_exists(current_ui)) {
		
		switch(current_station) {
			
			case STATION.BROTH:
				current_ui = instance_create_layer(0,0,"UI",obj_ui_broth);
			break;
			
			case STATION.NOODLES:
				current_ui = instance_create_layer(0,0,"UI",obj_ui_noodles);
			break;	
		}
	}
		
	
	// salir de la UI.
	if keyboard_check_pressed(vk_escape) {
		close_station();
	}
}