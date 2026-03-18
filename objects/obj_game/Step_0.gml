// Controles Tiempo
var dt = delta_time / 1000000;
dt *= time_scale_global;

// updates de sistemas
var systems = [broth, noodles, eggs, meat];
for (var i = 0; i < array_length(systems); i++) {
	
	var sys = systems[i];
	
	if (sys.should_update(current_station)) {
		sys.update(dt);
	}
}

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
			
			case STATION.EGGS:
				current_ui = instance_create_layer(0,0,"UI",obj_ui_eggs);
			break;	
			
			case STATION.MEAT:
				current_ui = instance_create_layer(0,0,"UI",obj_ui_meat);
			break;					
			
		}
	}
		
	
	// salir de la UI.
	if keyboard_check_pressed(vk_escape) {
		
		if (variable_instance_exists(current_ui, "block_exit") 
		&& current_ui.block_exit) return;
		
		close_station();
	}
}