if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var cl_button_w = sprite_get_width(spr_egg_serve_button);
var cl_button_h = sprite_get_width(spr_egg_serve_button);

var cl_button_x = display_get_gui_width() - cl_button_w * 0.5;
var cl_button_y = display_get_gui_height() - cl_button_h * 0.5;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var mouse_over_clear = 
	mx >= cl_button_x - cl_button_w * 0.5 &&
	mx <= cl_button_x + cl_button_w * 0.5 &&
	my >= cl_button_y - cl_button_h * 0.5 &&
	my <= cl_button_y + cl_button_h * 0.5;

var station = obj_game.eggs;

if (mouse_over_clear && mouse_check_button_pressed(mb_left)) {
	
	if (array_length(station.caught_eggs) > 0)
		obj_game.eggs.caught_eggs = [];
}