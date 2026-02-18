if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Tabla
draw_set_colour(#CCA57A);
draw_rectangle(board_x, board_y, board_x + board_w, board_y + board_h, false);


// Sheet de masas
if (obj_game.noodle_station.has_sheet) {
	
	var spr = spr_dough_sheet; 
	
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);
	
	var scale_x = sheet_w / sw;
	var scale_y = sheet_h / sh;
	
	var type = obj_game.noodle_station.type;
	
	draw_sprite(spr_dough_sheet, type, sheet_x, sheet_y);
	
	
	var cuts = obj_game.noodle_station.cuts;
	draw_set_colour(c_black);
	
	for (var i = 0; i < array_length(cuts); i++) {
		var cm = cuts[i];
		
		var cx = sheet_x + cm * 40;
		
		draw_line(cx, sheet_y, cx, sheet_y + sheet_h);
	}
}

for (var i = 0; i < array_length(dough); i++) {
	var d = dough[i];
	draw_sprite(d.sprite, 0, d.x, d.y);
}