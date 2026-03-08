if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);


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
if (station.station_state == EGG_STATION_STATE.CATCHING) {
	draw_sprite(
		spr_egg_basket,
		0,
		station.basket_x,
		station.basket_y
		);
}

var eggs_caught = station.caught_eggs;
var count = array_length(eggs_caught);
var offsets = [-16, 0, 16];

// Huevos Atrapados
if (station.station_state == EGG_STATION_STATE.CATCHING) {
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

// Mesa Serving
if (station.station_state == EGG_STATION_STATE.SERVING) {
	draw_sprite(spr_egg_table, 0, table_x, table_y);
}

// Huevos Serving
if (station.station_state == EGG_STATION_STATE.SERVING) {
	
	var spacing = 60;
	var start_x = table_x - (count - 1) * spacing * 0.5;
		
	
	for (var i = 0; i < count; i++) {
		
		var egg_c = eggs_caught[i];
		
		var egg_c_x = start_x + i * spacing;
		var egg_c_y = table_y + 25;
		

		draw_sprite_ext( 
			spr_egg,
			egg_c.sprite_frame,
			egg_c_x,
			egg_c_y,
			2, 2,
			0,
			c_white,
			1
		);
		
		if (dragging_egg) {
			draw_sprite_ext(
				spr_egg,
				drag_egg_frame,
				mx,
				my,
				2,2,
				0,
				c_white,
				1
			);
		}
	}
}
		
	
// Botón Clear y Serve
if (station.station_state == EGG_STATION_STATE.CATCHING) {
	draw_sprite(
		spr_egg_clear_button,
		0,
		cl_button_x,
		cl_button_y
	);

	draw_sprite(
		spr_egg_serve_button,
		0,
		srv_button_x,
		srv_button_y
	);
}

