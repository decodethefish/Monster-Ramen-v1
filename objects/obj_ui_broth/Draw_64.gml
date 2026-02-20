if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Ollas y Timers
for (var i = 0; i < array_length(obj_game.broth.pot_positions); i++) {
	
	var p_ui = obj_game.broth.pot_positions[i];
	var pot = obj_game.broth.pots[i];
	
	// ---- OLLA ----
	if (pot.broth_id == BROTH_ID.CHICKEN) {
		draw_sprite(spr_br_pot_ch, 0, p_ui.x, p_ui.y);
	}
	else if (pot.broth_id == BROTH_ID.ROTTEN) {
		draw_sprite(spr_br_pot_rt, 0, p_ui.x, p_ui.y);
	}
	else {
		draw_sprite(spr_br_pot, 0, p_ui.x, p_ui.y);
	}


	// ---- TIMER ---

	if (pot.broth_id != BROTH_ID.NONE) {

	    var bar_w = 100;
	    var bar_h = 10;
	    var bar_x = p_ui.x - bar_w * 0.5;
	    var bar_y = p_ui.y - 120;

	    var data = obj_game.broth.broth_data[pot.broth_id];

	    var ready_p = data.ready_time / data.burn_time;
	    var p = clamp(pot.progress / data.burn_time, 0, 1);

	    var x_ready = bar_x + bar_w * ready_p;
	    var x_end   = bar_x + bar_w;
	    var x_now   = bar_x + bar_w * p;

	    // fondo
	    draw_set_colour(c_grey);
	    draw_rectangle(bar_x, bar_y, x_end, bar_y + bar_h, false);

	    // verde
	    draw_set_colour(c_lime);
	    draw_rectangle(x_ready, bar_y, x_end, bar_y + bar_h, false);

	    // aguja
	    draw_set_colour(c_black);
	    draw_line_width(x_now, bar_y - 6, x_now, bar_y + bar_h + 6, 2);
	}
}


// Caldos
for (var i = 0; i < array_length(broths); i++) {
		var br = broths[i]
		draw_sprite(br.sprite, 0, br.x, br.y);
	}


// Switches
for (var i = 0; i < array_length(switches); i++) {
	
	var swi = switches[i];
	var pot = obj_game.broth.pots[swi.pot_index];
	
	draw_set_colour(pot.is_on ? c_lime : c_grey);
	
	draw_circle(swi.x,swi.y,swi.r,false);
}


// Bowls
for (var i = 0; i < array_length(bowls); i++) {
	var bw = bowls[i];
	
	if (!instance_exists(bw)) continue;
	
	obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
			
}
