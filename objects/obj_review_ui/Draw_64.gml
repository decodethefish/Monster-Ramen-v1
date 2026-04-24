// -------- FONDO ---------
draw_set_colour(c_dkgray);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// -------- PERSONAJE ---------
var c = obj_game.review.get_current_customer();
if (instance_exists(c)) {
	draw_sprite(spr_customer_npc, c.portrait_index_id, customer_x, customer_y);	
}

// -------- BOWLS ---------
draw_sprite(spr_review_tray, 0, tray_x, tray_y);
for (var i = 0; i < array_length(bowls); i++) {
	var bw = bowls[i];
	if (!instance_exists(bw)) continue ;
	obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
}

// -------- ESTRELLAS ---------
if (review_ready) {
	
	var star_count = 5;
	var star_spacing = 40;
	
	var start_x = half_w - (star_count - 1) * star_spacing * 0.5;
	var star_y = 48;
	
	var sw = sprite_get_width(spr_stars_review);
	var sh = sprite_get_height(spr_stars_review);
	
	for (var i = 0; i < star_count; i++) {
		
		var star_x = start_x + i * star_spacing;
		
		var star_value = clamp(stars - i, 0, 1);
		
		// ⭐ llena
		if (star_value >= 1) {
			draw_sprite(spr_stars_review, 1, star_x, star_y);
		}
		
		else if (star_value >= 0.5) {
			// ⭐media
			var ox = sprite_get_xoffset(spr_stars_review);
			var oy = sprite_get_yoffset(spr_stars_review);
			draw_sprite_part(
				spr_stars_review, 1,
				0, 0,
				sw * 0.5, sh,
				star_x - ox, star_y - oy
			);
		}
		else {
			// ⭐ vacía
			draw_sprite(spr_stars_review, 0, star_x, star_y);
		}
	}
}