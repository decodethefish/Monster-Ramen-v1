var station = obj_game.meat.meat_station;
var meats = station.available_meats;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (station.mode == MEAT_MODE.TENDER) {
	
	var layout = get_meat_layout ( 
		display_get_gui_width()/2,
		station.selector_y,
		meats,
		station.selector_spacing
	);

	// mouse over board
	var mleft   = station.board_x - station.board_w * 0.5;
	var mright  = station.board_x + station.board_w * 0.5;
	var mtop    = station.board_y - station.board_h * 0.5;
	var mbottom = station.board_y + station.board_h * 0.5;

	var mouse_over_board = (mx >= mleft && mx <= mright && my >= mtop && my <= mbottom);

	// mouse over carne
	var meat_w = sprite_get_width(spr_mt_meat_raw);
	var meat_h = sprite_get_height(spr_mt_meat_raw);

	var meat_left   = station.board_x - meat_w * 0.5;
	var meat_right  = station.board_x + meat_w * 0.5;
	var meat_top    = station.board_y - meat_h * 0.5;
	var meat_bottom = station.board_y + meat_h * 0.5;

	var mouse_over_meat = (
		station.has_meat &&
		mx >= meat_left && mx <= meat_right &&
		my >= meat_top && my <= meat_bottom
	);

	// mouse over bandeja
	var tleft   = station.tray_x - station.tray_w * 0.5;
	var tright  = station.tray_x + station.tray_w * 0.5;
	var ttop    = station.tray_y - station.tray_h * 0.5;
	var tbottom = station.tray_y + station.tray_h * 0.5;

	var mouse_over_tray = (
		mx >= tleft && mx <= tright &&
		my >= ttop && my <= tbottom
	);

	// drag and drop carne lista
	if (!dragging_ready 
	&& station.state == MEAT_STATE.READY_FOR_GRILL 
	&& mouse_over_meat
	&& mouse_check_button_pressed(mb_left)) {
	
			dragging_ready = true;

	}
	if (dragging_ready && mouse_check_button_released(mb_left)) {

		dragging_ready = false;
	
		if (mouse_over_tray) {
		
			var meat_data = obj_game.meat.end_tender();

			station.tray_has_meat = true;
		
			if (array_length(station.tray_meats) < station.tray_max) {
			
				array_push(station.tray_meats, {
					type: meat_data.type,
					tender_quality: meat_data.tender_quality,
					rot: irandom_range(-40, 40)
				});
			}
		
			obj_game.meat.reset();
			show_debug_message(meat_data);
		}
	}


	// mouse over carnes
	mouse_over_index = -1;
	for (var i = 0; i < array_length(layout); i++) {
	
		var r = layout[i];
	
	    if (mx >= r.left && mx <= r.right && my >= r.top && my <= r.bottom) {
	        mouse_over_index = i;
		}
	}

	// drag carnes crudas
	if (!dragging_raw && !station.hammer_picked && mouse_over_index != -1 && mouse_check_button_pressed(mb_left)) {
		dragging_raw = true;
		drag_meat_id = meats[mouse_over_index];
	}
	if (dragging_raw && mouse_check_button_released(mb_left)) {
	
		dragging_raw = false;
	
		if (mouse_over_board) {
			obj_game.meat.start_meat(drag_meat_id);
		}
	}

	// mouse over mazo
	var hammer_enabled = (station.state != MEAT_STATE.READY_FOR_GRILL);

	var hleft   = station.hammer_home_x - station.hammer_home_w * 0.5;
	var hright  = station.hammer_home_x + station.hammer_home_w * 0.5;
	var htop    = station.hammer_home_y - station.hammer_home_h * 0.5;
	var hbottom = station.hammer_home_y + station.hammer_home_h * 0.5;

	var mouse_over_home = (mx >= hleft && mx <= hright && my >= htop && my <= hbottom);

	if (!hammer_enabled) {
		station.hammer_picked = false;
		station.tender_running = false;
	}

	if (mouse_check_button_pressed(mb_left)) {

		if (hammer_enabled && !station.hammer_picked && mouse_over_home && !dragging_raw) {
			station.hammer_picked = true;
			station.hammer_offset_x = 0;
			station.hammer_offset_y = 40;
		}
	
		else if (hammer_enabled && station.hammer_picked && mouse_over_home) {
			station.hammer_picked = false;
			station.tender_running = false;	
		}
	}

	// golpe mazo
	if (hammer_enabled && station.hammer_picked && station.has_meat && mouse_over_meat && mouse_check_button_pressed(mb_left)) {
	    station.hammer_frame = 1;
		obj_game.meat.hit_tender();
	}

	station.tender_input = (
		hammer_enabled &&
		mouse_check_button(mb_left) &&
		station.tender_running &&
		station.hammer_picked &&
		mouse_over_meat
	);

	if (station.hammer_frame == 1 && mouse_check_button_released(mb_left)) {
	    station.hammer_frame = 0;
	}
	
	// inicio tender
	if (hammer_enabled && station.hammer_picked && station.has_meat && station.state == MEAT_STATE.RAW) {
		obj_game.meat.try_start_tender();
	}

	// botón cook
	var cook_left   = station.cook_b_x - station.cook_b_w * 0.5;
	var cook_right  = station.cook_b_x + station.cook_b_w * 0.5;
	var cook_top    = station.cook_b_y - station.cook_b_h * 0.5;
	var cook_bottom = station.cook_b_y + station.cook_b_h * 0.5;

	var mouseover_cook = mx >= cook_left && mx <= cook_right && my >= cook_top && my <= cook_bottom;

	if (mouseover_cook && mouse_check_button_pressed(mb_left)) {
	    station.mode = MEAT_MODE.COOK;
	}
}

if (station.mode == MEAT_MODE.COOK) {

	var layout = obj_game.meat.set_cook_tray_geometry(display_get_gui_height());
	var tray = station.tray_meats;

	// grill 
	var gleft   = station.grill_x - station.grill_w * 0.5;
	var gright  = station.grill_x + station.grill_w * 0.5;
	var gtop    = station.grill_y - station.grill_h * 0.5;
	var gbottom = station.grill_y + station.grill_h * 0.5;

	var mouse_over_grill =
	    mx >= gleft && mx <= gright &&
	    my >= gtop && my <= gbottom;

	// -----------------------------
	// DRAG TRAY → GRILL
	// -----------------------------
	
	mouseover_cook_index = -1;
	for (var i = 0; i < array_length(layout); i++) {
	    var l = layout[i];

	    if (mx >= l.left && mx <= l.right && my >= l.top && my <= l.bottom) {
	        mouseover_cook_index = i;
	    }
	}
		
	if (!dragging_cook && mouseover_cook_index != -1 && mouse_check_button_pressed(mb_left)) {

	    dragging_cook = true;
	    drag_meat = tray[mouseover_cook_index];

	    array_delete(station.tray_meats, mouseover_cook_index, 1);
	}
	
	if (dragging_cook && mouse_check_button_released(mb_left)) {

	    var dropped = false;

	    if (mouse_over_grill) {

			for (var i = 0; i < 2; i++) {

			    if (station.grill_slots[i] == noone) {

			        station.grill_slots[i] = {
			            type: drag_meat.type,
			            tender_quality: drag_meat.tender_quality,
			            cook_time: 0,
			            in_window: false,
						is_burned: false
			        };

			        dropped = true;
			        break;
			    }
			}
	    }

	    if (!dropped) {
	        array_push(station.tray_meats, drag_meat);
	    }

	    dragging_cook = false;
	    drag_meat = -1;
	}

	// -----------------------------
	// DRAG GRILL → BOWL
	// -----------------------------
	
	var grill = station.grill_slots;

	var spacing = sprite_get_height(spr_mt_meat_ready) + 20;
	var gx = station.grill_x;
	var top_y = station.grill_y - spacing * 0.5;
	var bottom_y = station.grill_y + spacing * 0.5;

	var mouse_over_grill_index = -1;

	for (var i = 0; i < 2; i++) {

		if (grill[i] == noone) continue;

		var gy = (i == 0) ? top_y : bottom_y;

		var w = sprite_get_width(spr_mt_meat_done);
		var h = sprite_get_height(spr_mt_meat_done);

	    var left   = gx - w * 0.5;
	    var right  = gx + w * 0.5;
	    var top    = gy - h * 0.5;
	    var bottom = gy + h * 0.5;		

		if (mx >= left && mx <= right && my >= top && my <= bottom) {
			mouse_over_grill_index = i;	
		}
	}

	if (!dragging_grill && mouse_over_grill_index != -1 && mouse_check_button_pressed(mb_left)) {
		
		dragging_grill = true;
		drag_meat = grill[mouse_over_grill_index];
		drag_slot = mouse_over_grill_index;

		station.grill_slots[mouse_over_grill_index] = noone;
	}

	if (dragging_grill && mouse_check_button_released(mb_left)) {

		var dropped = false;

		for (var i = 0; i < array_length(bowls); i++) {

			var bw = bowls[i];
		
			var bw_w = sprite_get_width(spr_bowl_base);
			var bw_h = sprite_get_height(spr_bowl_base);
		
			var left = bw.x - bw_w * 0.5;
			var right = bw.x + bw_w * 0.5;
			var top = bw.y - bw_h * 0.5;
			var bottom = bw.y + bw_h * 0.5;
		
			var mouse_over_bowl = 
				mx > left &&
				mx < right &&
				my > top &&
				my < bottom;
				
			// soltar en bowl y añadir calidad
			if (mouse_over_bowl) {

				var final_q = obj_game.meat.get_meat_final_quality(drag_meat);

				obj_game.bowls.add_meat(bw.bowl_index, {
					type: drag_meat.type,
					quality: final_q
				});

				dropped = true;
				break;
			}
		}

		if (!dropped) {
		    station.grill_slots[drag_slot] = drag_meat;
		}

		dragging_grill = false;
		drag_meat = -1;
	}
	
	// -----------------------------
	// BOTÓN TENDER
	// -----------------------------
		
	var tleft   = station.tender_b_x - station.tender_b_w * 0.5;
	var tright  = station.tender_b_x + station.tender_b_w * 0.5;
	var ttop    = station.tender_b_y - station.tender_b_h * 0.5;
	var tbottom = station.tender_b_y + station.tender_b_h * 0.5;

	var mouseover_tender =
		mx >= tleft && mx <= tright &&
		my >= ttop && my <= tbottom;

	if (mouseover_tender && mouse_check_button_pressed(mb_left)) {
		station.mode = MEAT_MODE.TENDER;
	}	
		
}