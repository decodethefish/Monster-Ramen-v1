if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Tabla
var station = obj_game.noodles.noodle_station;
draw_sprite(spr_nd_board, 0, station.board_x, station.board_y);

// Sheet de masas
if (obj_game.noodles.noodle_station.has_sheet) {
	
	var spr = spr_nd_sheet; 
	
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);

	
	var type = obj_game.noodles.noodle_station.type;
	
	var draw_x = station.sheet_x + station.warning_offset_x;
	
	// sprite sheet
	draw_sprite(
	    spr_nd_sheet,
	    station.type,
	    draw_x,
	    station.sheet_y
	);
	
	// brillo de warning
	if (station.warning_glow > 0)  {
		draw_sprite_ext(
		    spr_nd_sheet_glow,
			0,
		    draw_x,
		    station.sheet_y,
			1, 1,
			0,
			c_white,
			station.warning_glow
		);
	}

	
	
	var cuts = obj_game.noodles.noodle_station.cuts;
	draw_set_colour(c_black);
	
	var half_w = sw * 0.5;
	var half_h = sh * 0.5;
	
	var left_edge = draw_x - half_w;
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

// Bowls
for (var i = 0; i < array_length(bowls); i++) {
	var bw = bowls[i];
	
	if (!instance_exists(bw)) continue;
	
	obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
			
}
