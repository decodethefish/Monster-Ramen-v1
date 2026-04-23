// Fondo
draw_set_colour(c_dkgray);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Personaje
var c = obj_game.customers.current_review_customer;
if (instance_exists(c)) {
	draw_sprite(spr_customer_npc, c.portrait_index_id, customer_x, customer_y);	
}

// Bowls
draw_sprite(spr_review_tray, 0, tray_x, tray_y);
for (var i = 0; i < array_length(bowls); i++) {
	var bw = bowls[i];
	if (!instance_exists(bw)) continue;
	obj_game.bowls.draw(bw.bowl_index, bw.x, bw.y);
}