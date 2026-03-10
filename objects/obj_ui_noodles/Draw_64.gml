if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Tabla
var station = obj_game.noodles.noodle_station;
draw_sprite(spr_nd_board, 0, station.board_x, station.board_y);

// Sheet de masa
if (obj_game.noodles.noodle_station.has_sheet) {
	
	var spr = spr_nd_sheet; 
	
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);

	
	var draw_x = station.sheet_x;
	
	// sprite sheet fijo
	draw_sprite(spr_nd_sheet, 0, draw_x, station.sheet_y);
	
	var cuts = obj_game.noodles.noodle_station.cuts;
	draw_set_colour(c_black);
	
	var half_w = sw * 0.5;
	var half_h = sh * 0.5;
	
	var left_edge = draw_x - half_w;
	var px_per_cm = sw / 10;
	
		// cortes
	for (var i = 0; i < array_length(cuts); i++) {
		
		var cm = cuts[i];
		
		var cut_x = left_edge + cm * px_per_cm;
		
		draw_sprite(spr_nd_cut, 0, cut_x, station.sheet_y);
	}
	
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	var mouse_over_sheet = 
		mx >= draw_x - half_w &&
		mx <= draw_x + half_w &&
		my >= station.sheet_y - half_h &&
		my <= station.sheet_y + half_h;
		
	// lineas
	if (mouse_over_sheet) {
			
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
	
// Masa
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