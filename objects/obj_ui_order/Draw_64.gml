  if (obj_game.game_mode != GAME_MODE.COOKING) exit;

if (interaction == noone) exit;

// Fondo
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Texto
draw_set_colour(c_white);
draw_set_halign(fa_center);

var lines = interaction.dialog_lines;
var i = interaction.dialog_index;

if (is_array(lines) && i < array_length(lines)) {
    draw_text(half_w, 300, lines[i]);
}