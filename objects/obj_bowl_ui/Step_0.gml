var left = x - sprite_width * 0.5
var right = x + sprite_width * 0.5
var top = y - sprite_height * 0.5
var bottom = y + sprite_height * 0.5

var mouse_over = 
	mouse_x >= left && mouse_x <= right &&
	mouse_y >= top && mouse_y <= bottom;
	
var station_id = obj_game.current_station;
var drag_locked = obj_game.bowls.is_drag_locked_for_station(station_id);


// drag & drop
if (drag_locked) {
	if (dragging) {
		dragging = false;
		global.bowl_drag_active = false;
		x = x_start;
		y = y_start;
	}
	return;
}

if (mouse_over && mouse_check_button_pressed(mb_left) && !global.bowl_drag_active) {
	dragging = true;
	global.bowl_drag_active = true;
}
if (dragging) {
	x = mouse_x;
	y = mouse_y;
}
	
// drop en estaciones
if (dragging && mouse_check_button_released(mb_left)) {
	
	dragging = false;
	global.bowl_drag_active = false;
	
	// ------- Intentar servir BROTH ------
	if (obj_game.current_station == STATION.BROTH) {
		
		var pot_index = obj_game.broth.get_pot_at_position(x, y);
	
		obj_game.bowls.add_broth(
			bowl_index,
			pot_index,
			obj_game.broth.pots
		);
	}
	
	// ------- Intentar servir NOODLES ------
	
	if (obj_game.current_station == STATION.NOODLES) {
	
		var station = obj_game.noodles.noodle_station;
	
		if (obj_game.noodles.can_serve()) {
		
			var sheet_width = sprite_get_width(spr_nd_sheet);
			var sheet_height = sprite_get_height(spr_nd_sheet);
		
			var half_w = sheet_width * 0.5;
			var half_h = sheet_height * 0.5;
		
		
		    if (x >= station.sheet_x - half_w &&
		        x <= station.sheet_x + half_w &&
		        y >= station.sheet_y - half_h &&
		        y <= station.sheet_y + half_h) {
				
					var result = obj_game.noodles.get_result();
				
					obj_game.bowls.add_noodles(bowl_index, result);
					obj_game.noodles.reset();
			}
		}
	}
		
	// ------- Intentar servir MEAT ------

	if (obj_game.current_station == STATION.MEAT) {

		if (obj_game.meat.dragging_grill) { // o tu flag real

			var m = obj_game.meat.drag_meat;

			var final_q = obj_game.meat.get_meat_final_quality(m);

			obj_game.bowls.add_meat(bowl_index, {
				type: m.type,
				quality: final_q
			});

			// limpiar drag
			obj_game.meat.dragging_grill = false;
			obj_game.meat.drag_meat = -1;
			
		}
	}
	
	x = x_start;
	y = y_start;
	
}