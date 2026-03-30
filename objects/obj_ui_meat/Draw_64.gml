if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var station = obj_game.meat.meat_station;
var meats = station.available_meats;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (station.mode == MEAT_MODE.TENDER) {
	
	// Fondo
	draw_set_colour(c_brown);
	draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

	var layout = get_meat_layout ( 
		display_get_gui_width()/2,
		station.selector_y,
		meats,
		station.selector_spacing
	);
	// Tabla
	draw_sprite(spr_mt_board, 0, station.board_x, station.board_y);

	// bandeja
	if (station.state == MEAT_STATE.READY_FOR_GRILL || station.tray_has_meat) {
		draw_sprite(spr_mt_tray, 0, station.tray_x, station.tray_y);
	
		var tray = station.tray_meats;
	
		for (var i = 0; i < array_length(tray); i++) {
	
			var m = tray[i];
		
			draw_sprite_ext(
				spr_mt_meat_ready,
				m.type -1,
				station.tray_x,
				station.tray_y,
				1, 1,
				m.rot,
				c_white,
				1
			);
		}
	
	}



	// dibujar carnes sobre table
	if (station.has_meat && !dragging_ready) {

		if (station.state == MEAT_STATE.READY_FOR_GRILL) {
			draw_sprite(spr_mt_meat_ready, station.type -1, station.board_x, station.board_y);
		} 
		else {
			draw_sprite(spr_mt_meat_raw, station.type -1, station.board_x, station.board_y);
		}
	}
	if (dragging_ready) {
		draw_sprite(spr_mt_meat_ready, station.type -1, mx, my);
	}

	// dibujar carnes drag
	for (var i = 0; i < array_length(layout); i++) {

	    var r = layout[i];
	    var meat_id = meats[i];

		draw_set_colour(c_white);
	    draw_sprite(spr_mt_meats, meat_id -1, r.x, r.y);
	}
	if (dragging_raw) {
	    draw_sprite(spr_mt_meats_drag, drag_meat_id -1, mx, my);
	}

	var mouse_over_index = -1;

	// home de mazo
	draw_sprite(spr_mt_hammer_home, 0, station.hammer_home_x, station.hammer_home_y);

	// mazo
	if (!station.hammer_picked) {
		draw_sprite(spr_mt_hammer, 0, station.hammer_home_x, station.hammer_home_y);
	} else {
		draw_sprite(
			spr_mt_hammer_hand, 
			station.hammer_frame, 
			mx,
			my + station.hammer_offset_y
		);
	}

	// barra de tender y timer
	if (station.state == MEAT_STATE.TENDER) {

		var bx = station.board_x + station.board_w * 0.35;
		var by = station.board_y;

		var bw = 20;
		var bh = station.board_h * 0.6;

		// fondo
		draw_set_colour(c_gray);
		draw_rectangle(bx - bw/2, by - bh/2, bx + bw/2, by + bh/2, false);

		// segmentos (visual de lógica)
		var segments = station.tender_segments;
		var segment_h = bh / segments;

		var colors = [c_red, c_orange, c_yellow, c_lime, c_aqua, c_fuchsia];

		for (var i = 0; i < segments; i++) {

			var top = by - bh/2 + i * segment_h;
			var bottom = top + segment_h;

			draw_set_colour(colors[i]);
			draw_rectangle(bx - bw/2, top, bx + bw/2, bottom, false);
		}

		// cursor (vertical)
		var cy = by - bh/2 + (station.tender_value / 10) * bh;

		draw_set_colour(c_black);
		draw_rectangle(bx - bw/2, cy - 2, bx + bw/2, cy + 2, false);
	
		// Barra de timer
		var data = obj_game.meat.meats_data[station.type];
		var time_ratio = station.tender_timer / data.tender_time;
		time_ratio = clamp(time_ratio, 0, 1);
	
		var tx = bx + bw/2 + 10;
		var ty = by;
		var tw = 5;
		var th = bh;
	
		draw_set_alpha(0.5);
		draw_set_colour(c_dkgray);
		draw_rectangle(
			tx - tw/2, 
			ty - th/2, 
			tx + tw/2, 
			ty + th/2, 
			false);
	
		var fill_h = th * time_ratio;
	
		draw_set_alpha(1);
		draw_set_colour(c_green);
		draw_rectangle(
			tx - tw/2,
			ty + th/2 - fill_h,
			tx + tw/2,
			ty + th/2,
			false);
	}

	// botón cook
	draw_sprite(spr_mt_cook_button, 0, station.cook_b_x, station.cook_b_y);
	
}

if (station.mode == MEAT_MODE.COOK) {

    // Fondo
    draw_set_colour(c_dkgray);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
	
	// tray y grill
	var tray_w = sprite_get_width(spr_mt_cook_tray);
	var tray_h = sprite_get_height(spr_mt_cook_tray);
	var tray_y = station.cook_tray_center_y;

	draw_sprite(spr_mt_cook_tray, 0, 0 + tray_w * 0.5, tray_y);
	draw_sprite(spr_mt_grill, 0, station.grill_x, station.grill_y);
	
	// botón tender
	draw_sprite(spr_mt_tender_button, 0, station.tender_b_x, station.tender_b_y);
	
	// carnes en grill
	var grill = station.grill_slots;

	var gx = station.grill_x;

	var spacing = sprite_get_height(spr_mt_meat_ready) + 20;

	var top_y = station.grill_y - spacing * 0.5;
	var bottom_y = station.grill_y + spacing * 0.5;

	for (var i = 0; i < 2; i++) {

	    var gm = grill[i];
	    if (gm == noone) continue;

	    var gy = (i == 0) ? top_y : bottom_y;

	    // carne
		if (gm.is_burned) {
		    draw_sprite(spr_mt_meat_burned, gm.type -1, gx, gy); // o burned después
		}
		else if (gm.in_window) {
		    draw_sprite(spr_mt_meat_done, gm.type -1, gx, gy);
		}
		else {
		    draw_sprite(spr_mt_meat_ready, gm.type -1, gx, gy);
		}

	    var data = obj_game.meat.meats_data[gm.type];

	    var t = gm.cook_time;
	    var total = data.cook_time;
	    var ready = data.cook_ready_time;

	    // barra
	    var bar_w = 8;
	    var bar_h = 80;

	    var bx = gx + sprite_get_width(spr_mt_meat_ready) * 0.5 + 10;
	    var by = gy - bar_h * 0.5;

	    draw_set_colour(c_black);
	    draw_rectangle(bx, by, bx + bar_w, by + bar_h, false);

	    var ready_ratio = ready / total;
	    var ry = by + bar_h - bar_h * ready_ratio;

	    draw_set_colour(c_lime);
	    draw_rectangle(bx, by, bx + bar_w, ry, false);

	    var ratio = clamp(t / total, 0, 1);
	    var py = by + bar_h - bar_h * ratio;

	    draw_set_colour(c_white);
	    var line_h = 2;

	    draw_rectangle(
	        bx,
	        py - line_h * 0.5,
	        bx + bar_w,
	        py + line_h * 0.5,
	        false
	    );
	}

	// carnes en tray
    var tray = station.tray_meats;
    var count = array_length(tray);

    var base_x = 70;
    var center_y = station.cook_tray_center_y;

    var spacing = sprite_get_height(spr_mt_meat_ready_cook) * 0.7;

    var start_y = center_y - (count - 1) * spacing * 0.5;

    for (var i = 0; i < count; i++) {

        var t = tray[i];

        var yy = start_y + i * spacing;

        draw_sprite(
            spr_mt_meat_ready_cook,
            t.type -1,
            base_x,
            yy
        );
    }

    // carne arrastrándose
    if (dragging_cook) {

        draw_sprite(
            spr_mt_meat_ready_cook,
            drag_meat.type -1,
            mx,
            my
        );
    }
	
	// bowls
	for (var i = 0; i < array_length(bowls); i++) {

		var bw = bowls[i];
		obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
	}
	
	// carne done
	if (dragging_grill) {

		if (drag_meat.is_burned) {
		    draw_sprite(spr_mt_meat_burned_drag, drag_meat.type -1, mx, my);
		}
		else if (drag_meat.in_window) {
		    draw_sprite(spr_mt_meat_done_drag, drag_meat.type -1, mx, my);
		}
		else {
		    draw_sprite(spr_mt_meat_ready_cook, drag_meat.type -1, mx, my);
		}
	}
	
}