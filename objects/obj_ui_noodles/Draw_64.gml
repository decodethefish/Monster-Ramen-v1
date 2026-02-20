if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Tabla
<<<<<<< Updated upstream
draw_set_colour(#CCA57A);
draw_rectangle(board_x, board_y, board_x + board_w, board_y + board_h, false);

=======
var station = obj_game.noodles.noodle_station;
draw_sprite(spr_nd_board, 0, station.board_x, station.board_y);
>>>>>>> Stashed changes

// Sheet de masas
if (obj_game.noodles.noodle_station.has_sheet) {
	
	var spr = spr_nd_sheet; 
	
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);
	
	var scale_x = sheet_w / sw;
	var scale_y = sheet_h / sh;
	
	var type = obj_game.noodles.noodle_station.type;
<<<<<<< Updated upstream
	
	draw_sprite(spr_dough_sheet, type, sheet_x, sheet_y);
=======

	draw_sprite(
	    spr_nd_sheet,
	    station.type,
	    station.sheet_x,
	    station.sheet_y
	);
>>>>>>> Stashed changes
	
	
	var cuts = obj_game.noodles.noodle_station.cuts;
	draw_set_colour(c_black);
	
	var half_w = sw * 0.5;
	var half_h = sh * 0.5;
	
	var left_edge = station.sheet_x - half_w;
	var px_per_cm = sw / 10;
	
	for (var i = 0; i < array_length(cuts); i++) {
		
		var cm = cuts[i];
		
		var cut_x = left_edge + cm * px_per_cm;
		
		draw_sprite(spr_nd_cut, 0, cut_x, station.sheet_y);
	}
}
	
// Masas
for (var i = 0; i < array_length(dough); i++) {
	var d = dough[i];
	draw_sprite(d.sprite, 0, d.x, d.y);
}	

for (var i = 0; i < array_length(dough); i++) {
	var d = dough[i];
	draw_sprite(d.sprite, 0, d.x, d.y);
}