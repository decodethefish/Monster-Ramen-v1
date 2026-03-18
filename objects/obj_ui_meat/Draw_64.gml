if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

var station = obj_game.meat.meat_station;
var meats = station.available_meats;

draw_meat_row(
	display_get_gui_width() / 2,
	station.selector_y,
	station.available_meats,
	station.selector_spacing
);
