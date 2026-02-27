if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Masas drag & drop
for (var i = 0; i < array_length(dough); i++) {
	var d = dough[i]
	
	var w = sprite_get_width(d.sprite);
	var h = sprite_get_height(d.sprite);
	
	var left = d.x - w * 0.5;
	var right = d.x + w * 0.5;
	var top = d.y - h * 0.5;
	var bottom = d.y + h * 0.5;
	
	var mouse_over = 
		mx >= left && mx <= right &&
		my >= top && my <= bottom;
	
	// drag
	if (mouse_over && mouse_check_button_pressed(mb_left)) {
		d.dragging = true;
	}
	
	if (d.dragging) {
		d.x = mx;
		d.y = my;
	}
	
	var station = obj_game.noodles.noodle_station;
	
	// soltar
	if (d.dragging && mouse_check_button_released(mb_left)) {
		
		d.dragging = false;
		
		if (mx >= station.board_x - station.board_w * 0.5 &&
		    mx <= station.board_x + station.board_w * 0.5 &&
		    my >= station.board_y - station.board_h * 0.5 &&
		    my <= station.board_y + station.board_h * 0.5) {
	
			obj_game.noodles.start_sheet(d.recipe_id, obj_game.current_order.noodle_target_cm);
		}
		
		d.x = d.x_start;
		d.y = d.y_start;
	}
	
	dough[i] = d;
}
	
if (!obj_game.noodles.noodle_station.has_sheet) exit;

// Cortar sheet
if (mouse_check_button_pressed(mb_left)) {
	
	var dragging_any = false;
	for (var i = 0; i < array_length(dough); i++) {
		if (dough[i].dragging) {
			dragging_any = true;
			break;
		}
	}
	if (dragging_any) exit;
	
	var station = obj_game.noodles.noodle_station;
	var sheet_width = sprite_get_width(spr_nd_sheet);
	var sheet_height = sprite_get_height(spr_nd_sheet);
	var half_w = sheet_width * 0.5;
	var half_h = sheet_height * 0.5;

	if (mx >= station.sheet_x - half_w &&
	    mx <= station.sheet_x + half_w &&
	    my >= station.sheet_y - half_h &&
	    my <= station.sheet_y + half_h) {
		
		// borde izquierdo
		var left_edge = station.sheet_x - half_w;
		// pixeles x cm
		var px_per_cm = sheet_width / 10;
		
		var raw_cm = (mx - left_edge) / px_per_cm;
		var cm = round(raw_cm * 10) / 10;

		
		// limitar rango valido	
		var min_distance = 0.2;
		var too_close = false;
		
		var cuts = station.cuts;
		
		for (var i = 0; i < array_length(cuts); i++) {
			if (abs(cuts[i] - cm) < min_distance) {
				too_close = true;
				break;
			}
		}
		
		if (!too_close && cm > 0 && cm < 10) {
			obj_game.noodles.add_cut(cm);
		}
	}
}
	