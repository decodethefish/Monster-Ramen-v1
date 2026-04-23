var center_x = display_get_gui_width() * 0.5;
var arr = obj_game.tickets.tickets;

// -------- cuerda --------
draw_set_colour(c_black);
draw_line(0, y_anchor - 20, display_get_gui_width(), y_anchor - 20);

// -------- tickets pequeños--------
var count = array_length(arr);
var start_x = center_x - (count - 1) * spacing * 0.5;
var draw_i = 0;

for (var i = 0; i < array_length(arr); i++) {

	var t = arr[i];
	if (t == noone) continue;

	var tx = start_x + draw_i * spacing;
	var ty = y_anchor;

	// guardar posición REAL para hover
	t.draw_x = tx;
	t.draw_y = ty;

	draw_sprite(spr_tk_stations, draw_i, tx, ty);

	draw_i++;
}

// -------- ticket grande (hover) --------
if (hover_index != -1) {

	var t = arr[hover_index];

	if (t != noone) {

		var tx = t.draw_x;

		var th = sprite_get_height(spr_tk_stations) * 0.5;
		var tbh = sprite_get_height(spr_tk_base) * 0.5;

		var base_y = t.draw_y + th + tbh + 10;
		var ty = base_y + preview_offset;

		obj_game.tickets.draw(t, tx, ty);
	}
}