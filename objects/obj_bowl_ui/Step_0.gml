var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var left = x - sprite_width * 0.5;
var right = x + sprite_width * 0.5;
var top = y - sprite_height * 0.5;
var bottom = y + sprite_height * 0.5;

var mouse_over = 
	mx >= left && mx <= right &&
	my >= top && my <= bottom;
	
var station_id = obj_game.current_station;
var drag_locked = false;
if (!is_undefined(station_id)) {
	drag_locked = obj_game.bowls.is_drag_locked_for_station(station_id)	;
}

// -------- DRAG ---------
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
	x = mx
	y = my;
}
	
// -------- DROP EN ESTACIONES ---------
if (dragging && mouse_check_button_released(mb_left)) {
	
	dragging = false;
	global.bowl_drag_active = false;
	
// ------- REVIEW ----------
if (obj_game.current_modal_ui != noone) {

    var c = obj_game.review.get_current_customer();

    if (instance_exists(c)) {

        var ui = obj_game.current_modal_ui
        var cx = ui.customer_x;
        var cy = ui.customer_y;

        var spr = spr_customer_npc;
        var w = sprite_get_width(spr);
        var h = sprite_get_height(spr);

        var left = cx - w * 0.5;
        var right = cx + w * 0.5;
        var top = cy - h * 0.5;
        var bottom = cy + h * 0.5;

        var over_customer =
            mx >= left && mx <= right &&
            my >= top && my <= bottom;

        if (over_customer) {
            show_debug_message("SERVE BOWL:" + string(bowl_index));

            obj_game.review.try_serve_bowl(bowl_index);
            return;
        }
    }
}
	
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