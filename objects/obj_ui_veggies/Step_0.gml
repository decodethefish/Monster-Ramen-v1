if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var s = obj_game.veggies.veggie_station;

// TRASH
var tx = s.trash_x;
var ty = s.trash_y;
var tw = s.trash_w;
var th = s.trash_h;
function in_trash(_mx, _my, _x, _y, _w, _h) {
	return (
		_mx > _x - _w*0.5 &&
		_mx < _x + _w*0.5 &&
		_my > _y - _h*0.5 &&
		_my < _y + _h*0.5
	);
}

// GUIDE
var gx = s.guide_x;
var gy = s.guide_y;
var gw = s.guide_w;
var gh = s.guide_h;
function in_guide(_mx, _my, _x, _y, _w, _h) {
	return (
		_mx > _x - _w*0.5 &&
		_mx < _x + _w*0.5 &&
		_my > _y - _h*0.5 &&
		_my < _y + _h*0.5
	);
}

// HITBOX
function hit_sprite(_mx, _my, _x, _y, _spr) {
	var w = sprite_get_width(_spr);
	var h = sprite_get_height(_spr);
	
	return (
		_mx > _x - w*0.5 &&
		_mx < _x + w*0.5 &&
		_my > _y - h*0.5 &&
		_my < _y + h*0.5
	);
}
function in_board(_mx, _my, _s) {
	return (
		_mx > _s.board_x - _s.board_w * 0.5 &&
		_mx < _s.board_x + _s.board_w * 0.5 &&
		_my > _s.board_y - _s.board_h * 0.5 &&
		_my < _s.board_y + _s.board_h * 0.5
	);
}

// PICK
if (mouse_check_button_pressed(mb_left)) {

	// BOARD
	for (var i = array_length(s.board_items)-1; i >= 0; i--) {
		
		var it = s.board_items[i];
		
		var spr;
		switch (it.kind) {
			case ITEM_KIND.VEG: spr = spr_vg_board_veggies; break;
			case ITEM_KIND.GEM: spr = spr_vg_board_gems; break;
			case ITEM_KIND.RESULT: spr = spr_vg_board_veggies; break;
		}
		
		if (hit_sprite(mx, my, it.x, it.y, spr)) {
			
			it.origin_x = it.x;
			it.origin_y = it.y;
			it.from_board = true;
			
			s.drag_item = it;
			array_delete(s.board_items, i, 1);
			break;
			
		}
	}

	// VEG LANE
	if (s.drag_item == noone) {
		for (var i = array_length(s.veg_lane)-1; i >= 0; i--) {
			
			var it = s.veg_lane[i];
			var yy = s.veg_lane_y + s.item_spawn_y_offset;
			
			if (hit_sprite(mx, my, it.x, yy, spr_vg_lane_veggie)) {
				it.from_board = false;
				s.drag_item = it;
				array_delete(s.veg_lane, i, 1);
				break;
			}
		}
	}

	// GEM LANE
	if (s.drag_item == noone) {
		for (var i = array_length(s.gem_lane)-1; i >= 0; i--) {
			
			var it = s.gem_lane[i];
			var yy = s.gem_lane_y + s.item_spawn_y_offset;
			
			if (hit_sprite(mx, my, it.x, yy, spr_vg_lane_gems)) {
				it.from_board = false;
				s.drag_item = it;
				array_delete(s.gem_lane, i, 1);
				break;
			}
		}
	}
}

// DRAG
if (s.drag_item != noone) {
	s.drag_item.x = mx;
	s.drag_item.y = my;
}

// RETURN ANIMATION
for (var i = 0; i < array_length(s.board_items); i++) {
	
	var it = s.board_items[i];
	
	if (variable_struct_exists(it, "returning") && it.returning) {
		
		it.x = lerp(it.x, it.origin_x, 0.2);
		it.y = lerp(it.y, it.origin_y, 0.2);

		if (point_distance(it.x, it.y, it.origin_x, it.origin_y) < 1) {
			it.returning = false;
		}
	}
}

// DROP
if (mouse_check_button_released(mb_left)) {

	var drag = s.drag_item;
	var merged = false;

	if (drag != noone && is_struct(drag)) {

		// TRASH
		if (in_trash(mx, my, tx, ty, tw, th)) {
			s.drag_item = noone;
			exit;
		}

		// BOWLS
		for (var i = 0; i < array_length(bowls); i++) {
			
			var bw = bowls[i];
			
			var w = sprite_get_width(spr_bowl_base);
			var h = sprite_get_height(spr_bowl_base);

			var over = 
				mx > bw.x - w*0.5 && mx < bw.x + w*0.5 &&
				my > bw.y - h*0.5 && my < bw.y + h*0.5;

			if (over) {
				obj_game.bowls.add_veggie(i, drag);
				merged = true;
				break;
			}
		}

		// MERGE
		if (!merged) {
			for (var i = array_length(s.board_items)-1; i >= 0; i--) {
				
				var it = s.board_items[i];
				
				if (point_distance(mx, my, it.x, it.y) < 40) {

					var result = obj_game.veggies.combine_items(drag, it);

					if (result != noone) {

						array_delete(s.board_items, i, 1);

						var veg_type = (drag.kind != ITEM_KIND.GEM)
							? drag.veg_type
							: it.veg_type;

						var new_item = result;
						new_item.veg_type = veg_type;
						new_item.x = it.x;
						new_item.y = it.y;

						array_push(s.board_items, new_item);

						merged = true;
						break;
					}
				}
			}
		}

		// DROP NORMAL
		if (!merged && in_board(mx, my, s)) {

			if (array_length(s.board_items) < s.max_board_items) {
				
				var new_item = obj_game.veggies.board_item_create(drag, mx, my);
				array_push(s.board_items, new_item);
				merged = true;
			}
		}

		// RETURN
		if (!merged && drag.from_board) {
			
			drag.returning = true;
			array_push(s.board_items, drag);
		}

		s.drag_item = noone;
	}
}

// Click guía
if (mouse_check_button_pressed(mb_left)) {
	
	if (in_guide(mx, my, gx, gy, gw, gh)) {
		
		obj_game.veggies.open_guide = true;
		
		exit;
	}
}