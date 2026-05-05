function draw_ticket_details(_ticket, _x, _y) {
	if (!is_struct(_ticket)) return;
	
	var o = _ticket.order;
	if (is_undefined(o)) return;
	
	var cm_to_index = function(_cm) {
		switch (_cm) {
			case 1: return 0;
			case 2: return 1;
			case 4: return 2;
		}
		return 0;
	};

	draw_sprite(spr_tk_base, 0, _x, _y);
	draw_sprite(spr_tk_broth, o.broth - 1, _x, _y);
	draw_sprite(spr_tk_eggs, o.egg, _x, _y);

	var spr = -1;
	switch (o.veggies.type) {
		case VEGGIE_TYPE.CARROT: spr = spr_tk_carrot; break;
		case VEGGIE_TYPE.MUSHROOM: spr = spr_tk_mush; break;
		case VEGGIE_TYPE.BOK_CHOY: spr = spr_tk_bok; break;
	}
	if (spr != -1) draw_sprite(spr, o.veggies.result + 1, _x, _y);

	draw_sprite(spr_tk_noodles, 0, _x, _y);
	draw_sprite(spr_tk_centimeters, cm_to_index(o.noodles.target_cm), _x, _y);
	draw_sprite(spr_tk_runes, o.noodles.type - 1, _x, _y);
	draw_sprite(spr_tk_meats, o.meat.type - 1, _x, _y);
	draw_sprite(spr_tk_tender, o.meat.target_tender, _x, _y);
}

function draw_dock_for_station(_dock_x, _dock_y) { 
	
	// posiciones
	var eye_offset_x = -53;
	var eye_offset_y = -1;
	var tickets_offset_x = -10;
	var tickets_offset_y = -1;
	var tickets_spacing = 36;
	var preview_gap = 16;
	
	static dock_eye_scale = 1;
	static dock_eye_bump_scale = 1.2;
	static dock_eye_last_state = -1;
	
	static hover_index = -1;
	static preview_offset  = 0;
	static preview_active = false;
	static preview_index = -1;
	
	draw_sprite(spr_dock_base, 0, _dock_x, _dock_y);
	
	var state = obj_game.get_cooking_state();
	if (state != dock_eye_last_state) {
		dock_eye_bump_scale = 1.25;
		dock_eye_last_state = state;
	}
	
	dock_eye_bump_scale = lerp(dock_eye_bump_scale, 1, 0.2);
	dock_eye_scale = lerp(dock_eye_scale, dock_eye_bump_scale, 0.4);
	
	draw_sprite_ext(
		spr_burning_eye,
		state,
		_dock_x + eye_offset_x,
		_dock_y + eye_offset_y,
		dock_eye_scale,
		dock_eye_scale,
		0,
		c_white,
		1
	);
	
	var arr = obj_game.orders.get_tickets();
	var count = array_length(arr);
	if (count <= 0) return;
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	var center_x = _dock_x + tickets_offset_x;
	var anchor_y = _dock_y + tickets_offset_y;
	
	var start_x = _dock_x + tickets_offset_x;
	hover_index = -1;

	for (var i = 0; i < count; i++) {
		var t = arr[i];
		if (!is_struct(t)) continue;
		
		var tx = start_x + i * tickets_spacing;
		var ty = anchor_y;
		t.draw_x = tx;
		t.draw_y = ty;
		
		draw_sprite(spr_tk_stations, i, tx, ty);
		
		var w = sprite_get_width(spr_tk_stations);
		var h = sprite_get_height(spr_tk_stations);
		var over =
			mx >= tx - w * 0.5 && mx <= tx + w * 0.5 &&
			my >= ty - h * 0.5 && my <= ty + h * 0.5;

		if (over) hover_index = i;
		
		// -------- barra de tiempo --------
		var c = t.customer;
		if (instance_exists(c)) {

			var t_ratio = 1;

			switch (c.state) {
				case CUSTOMER_STATE.WAIT_FOOD:
					t_ratio = c.food_wait_timer / obj_game.customers.customer_food_wait_time;
				break;
		
				case CUSTOMER_STATE.WAIT:
					t_ratio = c.wait_timer / obj_game.customers.customer_wait_time;
				break;
		
				default:
					t_ratio = 1;
				break;
			}

			t_ratio = clamp(t_ratio, 0, 1);

			var bar_w = sprite_get_width(spr_tk_stations);
			var bar_h = 2;

			var bar_x1 = tx - bar_w * 0.5;
			var bar_y  = ty - sprite_get_height(spr_tk_stations) * 0.5 - 4;

			// fondo gris oscuro
			draw_set_colour(make_colour_rgb(40, 40, 40));
			draw_rectangle(bar_x1, bar_y, bar_x1 + bar_w, bar_y + bar_h, false);

			// ancho dinámico
			var fill_w = bar_w * t_ratio;

			// derecha fija → izquierda variable
			var fill_x2 = bar_x1 + bar_w;
			var fill_x1 = fill_x2 - fill_w;

			// color por porcentaje
			var col;
			if (t_ratio > 0.5) col = c_lime;
			else if (t_ratio > 0.15) col = c_yellow;
			else col = c_red;

			draw_set_colour(col);
			draw_rectangle(fill_x1, bar_y, fill_x2, bar_y + bar_h, false);
		}
	}
	
	if (hover_index != preview_index) {
		preview_index = hover_index;
		if (hover_index != -1) {
			preview_offset = -30;
			preview_active = true;
		}
	}
	
	if (preview_active) {
		preview_offset = lerp(preview_offset, 0, 0.30);
		if (abs(preview_offset) < 0.5) {
			preview_offset = 0;
			preview_active = false;
		}
	}
	
	if (hover_index != -1 && hover_index < count) {
		var ticket = arr[hover_index];
		if (is_struct(ticket)) {
			var tx_big = ticket.draw_x;
			var th = sprite_get_height(spr_tk_stations) * 0.5;
			var tbh = sprite_get_height(spr_tk_base) * 0.5;
			var ty_big = ticket.draw_y + th + tbh + preview_gap + preview_offset;
			draw_ticket_details(ticket, tx_big, ty_big);
		}
	}
}
