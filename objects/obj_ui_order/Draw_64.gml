if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

if (!dialog_done) {
	draw_text(half_w, 300, dialog_lines[dialog_index]);
}