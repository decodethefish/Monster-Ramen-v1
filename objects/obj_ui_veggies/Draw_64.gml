if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var station = obj_game.veggies.veggie_station;
var spr_base;
var spr_mod;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Tabla
draw_sprite(spr_vg_board, 0, station.board_x, station.board_y);

// Conveyors
draw_sprite(spr_vg_conveyor, 0, station.lane_x, station.veg_lane_y);
draw_sprite(spr_vg_conveyor, 0, station.lane_x, station.gem_lane_y);

// TRASH
draw_sprite(spr_vg_trash, 0, station.trash_x, station.trash_y);

// GUIDE
draw_sprite(spr_vg_guide, 0, station.guide_x, station.guide_y);

// VEG LANE
for (var i = 0; i < array_length(station.veg_lane); i++) {
	var it = station.veg_lane[i];
	var yy = station.veg_lane_y + station.item_spawn_y_offset;

	draw_sprite(
		spr_vg_lane_veggie,
		it.veg_type,
		it.x,
		yy
	);
}

// GEM LANE
for (var i = 0; i < array_length(station.gem_lane); i++) {
	var it = station.gem_lane[i];
	var yy = station.gem_lane_y + station.item_spawn_y_offset;

	draw_sprite(
		spr_vg_lane_gems,
		it.gem_type,
		it.x,
		yy
	);
}

// BOARD ITEMS
for (var i = 0; i < array_length(station.board_items); i++) {
	
	var it = station.board_items[i];
	
	switch (it.kind) {
		
		case ITEM_KIND.VEG:
			draw_sprite(spr_vg_board_veggies, it.veg_type, it.x, it.y);
		break;
		
		case ITEM_KIND.GEM:
			draw_sprite(spr_vg_board_gems, it.gem_type, it.x, it.y);
		break;
		
		case ITEM_KIND.RESULT:
			
			switch (it.veg_type) {
				case VEGGIE_TYPE.CARROT:   spr_mod = spr_vg_mod_carrot; break;
				case VEGGIE_TYPE.MUSHROOM: spr_mod = spr_vg_mod_mush; break;
				case VEGGIE_TYPE.BOK_CHOY: spr_mod = spr_vg_mod_bokchoy; break;
			}
			
			draw_sprite(spr_mod, it.result_type, it.x, it.y);
		break;
	}
}

// DRAG
var drag = station.drag_item;
if (drag != noone) {

	switch (drag.kind) {
		
		case ITEM_KIND.VEG:
			draw_sprite(spr_vg_board_veggies, drag.veg_type, drag.x, drag.y - 6);
		break;
		
		case ITEM_KIND.GEM:
			draw_sprite(spr_vg_board_gems, drag.gem_type, drag.x, drag.y - 6);
		break;
		
		case ITEM_KIND.RESULT:
			
			switch (drag.veg_type) {
				case VEGGIE_TYPE.CARROT:   spr_mod = spr_vg_mod_carrot; break;
				case VEGGIE_TYPE.MUSHROOM: spr_mod = spr_vg_mod_mush; break;
				case VEGGIE_TYPE.BOK_CHOY: spr_mod = spr_vg_mod_bokchoy; break;
			}
			
			draw_sprite(spr_mod, drag.result_type, drag.x, drag.y - 6);
		break;
	}
}
	
// BOWLS
for (var i = 0; i < array_length(bowls); i++) {
	
	var bw = bowls[i];
	obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
	
}
