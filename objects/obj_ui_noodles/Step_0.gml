if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Masas
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
	
	// soltar
	if (d.dragging && mouse_check_button_released(mb_left)) {
		
		d.dragging = false;
		
		if (mx >= board_x && mx <= board_x + board_w &&
			my >= board_y && my <= board_y + board_h) {
			
			with (obj_game) {
				noodle_start_sheet(d.recipe_id, current_order.noodle_target_cm);
			}
		}
		
		d.x = d.x_start;
		d.y = d.y_start;
	}
	
	dough[i] = d;
}
	
if (!obj_game.noodle_station.has_sheet) exit;

// Cortar masa
if (mouse_check_button_pressed(mb_left)) {
	
	var dragging_any = false;
	for (var i = 0; i < array_length(dough); i++) {
		if (dough[i].dragging) {
			dragging_any = true;
			break;
		}
	}
	if (dragging_any) exit;
	
	if (mx >= sheet_x && mx <= sheet_x + sheet_w &&
		my >= sheet_y && my <= sheet_y + sheet_h) {

		var raw_cm = (mx - sheet_x) / 40;
		var cm = round(raw_cm * 10) / 10;
		
		if (cm <= 0 || cm >= 10) return;
		
		var min_distance = 0.1;
		
		var cuts = obj_game.noodle_station.cuts;
		for (var i = 0; i < array_length(cuts); i++) {
			if (abs(cuts[i] - cm) < min_distance) {
				return;
			}
		}
		
		with (obj_game) {
			noodle_add_cut(cm)
		}
	}
}

if (keyboard_check_pressed(ord("F"))) {
	with (obj_game) {
		noodle_finish_sheet();
	}
}

