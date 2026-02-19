if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Tabla
draw_sprite(spr_noodle_board, 0, board_x, board_y);

// Masas
for (var i = 0; i < array_length(dough); i++) {
	var d = dough[i];
	draw_sprite(d.sprite, 0, d.x, d.y);
}

// Sheet de masas
if (obj_game.noodles.noodle_station.has_sheet) {
	
	var spr = spr_dough_sheet; 
	
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);

	
	var type = obj_game.noodles.noodle_station.type;
	
	var station = obj_game.noodles.noodle_station;

	draw_sprite(
	    spr_dough_sheet,
	    station.type,
	    station.sheet_x,
	    station.sheet_y
	);
	
	
	var cuts = obj_game.noodles.noodle_station.cuts;
	draw_set_colour(c_black);
	
	for (var i = 0; i < array_length(cuts); i++) {
		var cm = cuts[i];
		
		var cx = sheet_x + cm * 40;
		
		draw_line(cx, sheet_y, cx, sheet_y + sheet_h);
	}
}

// Bowls
for (var i = 0; i < array_length(bowls); i++) {
	var bw = bowls[i];
	
	if (!instance_exists(bw)) continue;
	
	obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
			
}
