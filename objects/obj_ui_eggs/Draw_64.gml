if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

var station = obj_game.eggs;


// Gallinas y plataforma
var center_x = display_get_gui_width() * 0.5;
var spacing = sprite_get_width(spr_egg_chicken_normal) * 2;
var group_width = (station.active_chickens - 1) * spacing;
var start_x = center_x - group_width * 0.5;
var ch_y = 80;

var ch_half = sprite_get_height(spr_egg_chicken_normal) * 0.5;
var plat_half = sprite_get_height(spr_egg_platform) * 0.5;
var plat_x = display_get_gui_width() * 0.5;
var plat_y = ch_y + ch_half + plat_half;

draw_sprite(spr_egg_platform, 0, plat_x, plat_y);

for (var i = 0; i < station.active_chickens; i++) {
	
	var ch = station.chickens[i];
	var ch_x = start_x + i * spacing + ch.x_position;
	var spr = station.chicken_sprites[ch.type];
	
	draw_sprite(spr, 0, ch_x, ch_y);
}
	