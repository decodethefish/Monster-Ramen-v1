var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var hovered_pot = obj_game.get_pot_at_position(mx, my);

// hover olla
for (var i = 0; i < array_length(obj_game.pot_positions); i++) {
	var ui = obj_game.pot_positions[i];
	
	var left = ui.x - potw * 0.5;
	var right = ui.x + potw * 0.5;
	var top = ui.y - poth * 0.5;
	var bottom = ui.y + poth * 0.5;
	
	if (device_mouse_x_to_gui(0) >= left && device_mouse_x_to_gui(0) <= right &&
		device_mouse_y_to_gui(0) >= top && device_mouse_y_to_gui(0) <= bottom) {
		
		hovered_pot = i;
		break;
		}
}

// caldos
for (var i = 0; i < array_length(broths); i++) {
	var br = broths[i];
	
	// tamaños y posiciones
	var w = sprite_get_width(br.sprite);
	var h = sprite_get_height(br.sprite);
	
	var left = br.x - w * 0.5;
	var right = br.x + w * 0.5;
	var top = br.y - h * 0.5;
	var bottom = br.y + h * 0.5;
	
	// drag y drop
	var mouse_over_br =
	device_mouse_x_to_gui(0) >= left &&
	device_mouse_x_to_gui(0) <= right &&
	device_mouse_y_to_gui(0) >= top &&
	device_mouse_y_to_gui(0) <= bottom;
	
	if (mouse_over_br && mouse_check_button_pressed(mb_left)) {
		br.dragging = true;
	}
	if (br.dragging) {
		br.x = device_mouse_x_to_gui(0);
		br.y = device_mouse_y_to_gui(0);
	}
	if (br.dragging && mouse_check_button_released(mb_left)) {
		br.dragging = false; 
		
		if (hovered_pot != -1) {
			var pot = obj_game.pots[hovered_pot];
			
			pot.broth_id = br.recipe_id;
			pot.progress = 0;
			pot.is_on = false;
			pot.state = POT_STATE.EMPTY;
			
			obj_game.pots[hovered_pot] = pot;

		}
		
		br.x = br.x_start;
		br.y = br.y_start;
	}
	
	broths[i] = br;
}


// Switches
if (mouse_check_button_pressed(mb_left)) {
	
	for (var i = 0; i < array_length(switches); i++) {
		
		var swi = switches[i];
		
		if (point_distance(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), swi.x, swi.y) <= swi.r) {
			
			var pot = obj_game.pots[swi.pot_index];

			if (!pot.is_on && pot.broth_id != BROTH_ID.NONE) {
				pot.is_on = true;
				pot.state = POT_STATE.COOKING;
				show_debug_message("clicked switch " + string(i));
			}
			else if (pot.is_on) {
				pot.is_on = false;
			}
			obj_game.pots[swi.pot_index] = pot;
			}
	}
}