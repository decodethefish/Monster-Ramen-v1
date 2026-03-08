if (obj_game.game_mode != GAME_MODE.COOKING) exit;

// Fondo
draw_set_colour(c_white);
draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);

var station = obj_game.eggs;

// Plataforma
var center_x = display_get_gui_width() * 0.5;

var ch_half = sprite_get_height(spr_egg_chicken_normal) * 0.5;
var plat_half = sprite_get_height(spr_egg_platform) * 0.5;
var plat_y = station.chicken_y + ch_half + plat_half;

draw_sprite(spr_egg_platform, 0, center_x, plat_y);

// Canasta
draw_sprite(
	spr_egg_basket,
	0,
	station.basket_x,
	station.basket_y
	);

var eggs_caught = station.caught_eggs;
var count = array_length(eggs_caught);
var offsets = [-16, 0, 16];

for (var i = 0; i < count; i++) {
	
	var egg = eggs_caught[i];
	
	var egg_x = station.basket_x + offsets[i];
	var egg_y = station.basket_y - 8;
	
	draw_sprite(
		spr_egg,
		egg.sprite_frame,
		egg_x,
		egg_y
	);

}

// Gallinas
for (var i = 0; i < station.active_chickens; i++) {

    var ch = station.chickens[i];
	var xscale = (ch.move_dir == 1) ? -1 : 1;
    var spr = station.chicken_sprites[ch.type];

    draw_sprite_ext(
        spr,
        0,
        ch.x,ch.y,
		xscale,
		1,
		0,
		c_white,
		1
    );

}
	
// Huevos
for (var i = 0; i < array_length(station.eggs); i++) {
	
	var egg = station.eggs[i]
	
	draw_sprite(spr_egg, egg.sprite_frame, egg.x, egg.y);
	
	
}

// Botón Clear
var cl_button_w = sprite_get_width(spr_egg_clear_button);
var cl_button_h = sprite_get_width(spr_egg_clear_button);

var cl_button_x = display_get_gui_width() - cl_button_w * 0.5;
var cl_button_y = display_get_gui_height() - cl_button_h * 0.5;

draw_sprite(
	spr_egg_clear_button,
	0,
	cl_button_x,
	cl_button_y
);
