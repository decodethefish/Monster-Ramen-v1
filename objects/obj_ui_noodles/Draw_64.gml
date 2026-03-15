if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Tabla
var station = obj_game.noodles.noodle_station;
draw_sprite(spr_nd_board, 0, station.board_x, station.board_y);

var is_transformed =
	station.state == NOODLE_STATE.RITUAL_TRANSFORM ||
	station.state == NOODLE_STATE.RITUAL_PATTERN ||
	station.state == NOODLE_STATE.RITUAL_INPUT ||
	station.state == NOODLE_STATE.RITUAL_FAIL;


if (is_transformed) {
	
	var cx = station.sheet_x;
	var cy = station.sheet_y;
	
	var progress = 1
	if (station.state == NOODLE_STATE.RITUAL_TRANSFORM) {
		progress = (120 - station.ritual_timer) / 120;
	}
	
	var alpha = clamp(progress, 0, 1);
	
	draw_set_alpha(alpha);
	draw_sprite(spr_nd_ritual_circle, station.ritual_type, cx, cy);
	
	draw_set_alpha(1);
	
	var rune_progress = clamp((progress - 0.4) / 0.6, 0, 1);
	draw_set_alpha(rune_progress);
	
	var rune_count = 6;
	
	// runas
	if (array_length(obj_game.noodles.ritual_rune_x) >= 6) {

		for (var i = 0; i < 6; i++) {

			var runex = obj_game.noodles.ritual_rune_x[i];
			var runey = obj_game.noodles.ritual_rune_y[i];
			var current = obj_game.noodles.get_current_rune();

			draw_sprite(spr_nd_ritual_runes, i, runex, runey);
		}
	}
	draw_set_alpha(1);
}

// Masa
if (station.has_sheet) {
	
	var spr = spr_nd_sheet; 
	
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);
	
	var draw_x = station.sheet_x;
	
	var half_w = sw * 0.5;
	var half_h = sh * 0.5;
	var left_edge = draw_x - half_w;
	var px_per_cm = sw / 10;

	if (!is_transformed) {
		
		draw_sprite(spr_nd_sheet, 0, draw_x, station.sheet_y);
		
		var cuts = obj_game.noodles.noodle_station.cuts;
		draw_set_colour(c_black);
	
			// cortes
		for (var i = 0; i < array_length(cuts); i++) {
		
			var cm = cuts[i];
			var cut_x = left_edge + cm * px_per_cm;
			draw_sprite(spr_nd_cut, 0, cut_x, station.sheet_y);
			
		}
		
	} else {
		
		draw_sprite(spr_nd_ball, 0, draw_x, station.sheet_y);
	}
	
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	var mouse_over_sheet = 
		mx >= draw_x - half_w &&
		mx <= draw_x + half_w &&
		my >= station.sheet_y - half_h &&
		my <= station.sheet_y + half_h;
		
	// lineas
	if (mouse_over_sheet && !station.ritual_active) {
			
		var board_h = sprite_get_height(spr_nd_board);
		var top = station.board_y - station.board_h * 0.5;
		var bottom = station.board_y + station.board_h * 0.5;
		var raw_cm = (mx - left_edge) / px_per_cm;
		var cm = round(raw_cm * 10) / 10;
		var line_x = left_edge + cm * px_per_cm;	
		
		draw_set_colour(c_black);
		
		var segment = 6;
		for (var i = top; i < bottom; i += segment * 2) {
			draw_line(line_x, i, line_x, i + segment);
		}
	}
}
	
// Masa arrastable
for (var i = 0; i < array_length(dough); i++) {
	var d = dough[i];
	draw_sprite(d.sprite, 0, d.x, d.y);
}	

// Bowls
for (var i = 0; i < array_length(bowls); i++) {
	var bw = bowls[i];
	
	if (!instance_exists(bw)) continue;
	
	obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
			
}

// Botón ritual
if (station.ritual_available && !station.ritual_complete) { 

	draw_sprite(spr_nd_choose_ritual, 0, rbutton_x, rbutton_y);
}

// UI selección de ritual
if (station.state == NOODLE_STATE.RITUAL_SELECT) {
	
	var gw = display_get_gui_width();
	var gh = display_get_gui_height();
	
	// oscurecer fondo
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_rectangle(0, 0, gw, gh, false);
	draw_set_alpha(1);
	
	// ventana
	
	var win_w = 496;
	var win_h = 140;
	var win_x = gw * 0.5 - win_w * 0.5;
	var win_y = gh * 0.5 - win_h * 0.5;
	
	draw_set_color(c_black);
	draw_rectangle(
		win_x, win_y,
		win_x + win_w,
		win_y + win_h,
		false
		);
	
	draw_set_color(c_white);
	draw_text(gw * 0.5 - 70, win_y + 10, "Choose Noodle Type");
	
	// symbols
	var symbols = ritual_symbols;
	var spr = spr_nd_ritual_symbols;
	var count = array_length(symbols);
	
	var spacing = 96;
	var start_x = gw * 0.5 - ((count - 1) * spacing) * 0.5;
	var sym_y = win_y + 80;
	
	for (var i = 0; i < count; i++) {
		
		var sym_x = start_x + i * spacing;
		
		ritual_symbol_x[i] = sym_x;
		ritual_symbol_y[i] = sym_y;
		
		draw_sprite(spr, i, sym_x, sym_y);
	}
}

draw_set_colour(c_black);
draw_text(20, 60, "LAST: " + string(station.ritual_last_pressed));