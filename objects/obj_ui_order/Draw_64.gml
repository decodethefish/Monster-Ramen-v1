if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

draw_set_colour(c_white);
draw_set_halign(fa_center);
if (dialog_index < array_length(dialog_lines)) {
    draw_text(half_w, 300, dialog_lines[dialog_index]);
}