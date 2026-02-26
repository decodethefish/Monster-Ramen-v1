var data = obj_game.bowls.bowls[bowl_index];


obj_game.bowls.draw(bowl_index, x, y);

var left = x - sprite_width * 0.5
var right = x + sprite_width * 0.5
var top = y - sprite_height * 0.5
var bottom = y + sprite_height * 0.5

var mouse_over = 
	mouse_x >= left && mouse_x <= right &&
	mouse_y >= top && mouse_y <= bottom;
	
// drag & drop

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
	
		if (obj_game.bowls.can_receive_broth(bowl_index)) {
			obj_game.bowls.add_broth(
				bowl_index,
				pot_index,
				obj_game.broth.pots
			);
		}
	}
	
	// ------- Intentar servir NOODLES ------
	
	if (obj_game.current_station == STATION.NOODLES) {
	
		var station = obj_game.noodles.noodle_station;
	
		if (obj_game.noodles.can_serve() && obj_game.bowls.can_receive_noodles(bowl_index)) {
		
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
	
	x = x_start;
	y = y_start;
	
}
	
	