if (obj_game.game_mode != GAME_MODE.COOKING) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var mouse_over_clear = 
	mx >= cl_button_x - cl_button_w * 0.5 &&
	mx <= cl_button_x + cl_button_w * 0.5 &&
	my >= cl_button_y - cl_button_h * 0.5 &&
	my <= cl_button_y + cl_button_h * 0.5;

var mouse_over_serve = 
	mx >= srv_button_x - srv_button_w * 0.5 &&
	mx <= srv_button_x + srv_button_w * 0.5 &&
	my >= srv_button_y - srv_button_h * 0.5 &&
	my <= srv_button_y + srv_button_h * 0.5;

var station = obj_game.eggs;

if (station.station_state == EGG_STATION_STATE.CATCHING) { 
	if (mouse_over_clear && mouse_check_button_pressed(mb_left)) {
		if (array_length(station.caught_eggs) > 0) {
			station.caught_eggs = [];
		}
	}
}

// Switch State
if (station.station_state == EGG_STATION_STATE.CATCHING) {
	if (mouse_over_serve && mouse_check_button_pressed(mb_left)) {
		station.station_state = EGG_STATION_STATE.SERVING;
	}
}

if (station.station_state != EGG_STATION_STATE.SERVING) exit;

// Huevos drag
var eggs_caught = station.caught_eggs;
var count = array_length(eggs_caught);
var eggs_start_x = table_x - (count - 1) * serving_egg_spacing * 0.5;

for (var i = 0; i < count; i++) {
	var egg_c = eggs_caught[i];
	
	var egg_c_x = eggs_start_x + i * serving_egg_spacing;
	var egg_c_y = serving_egg_y;
	
	var eleft   = egg_c_x - egg_c_w * 0.5;
	var eright  = egg_c_x + egg_c_w * 0.5;
	var etop    = egg_c_y - egg_c_h * 0.5;
	var ebottom = egg_c_y + egg_c_h * 0.5;
	
	var mouse_over_egg = 
		mx > eleft &&
		mx < eright &&
		my > etop &&
		my < ebottom;
	
	if (!dragging_egg && mouse_over_egg && mouse_check_button_pressed(mb_left)) {
		dragging_egg = true;
		drag_egg_index = i;
		drag_egg_type = egg_c.type;
		drag_egg_frame = egg_c.sprite_frame;
		
		array_delete(station.caught_eggs, i, 1);
		break;
	}
}

// Huevos drop
if (dragging_egg && mouse_check_button_released(mb_left)) {
	var dropped = false;
	
	for (var i = 0; i < array_length(bowls); i++) {
		var bw = bowls[i];
		
		var bw_w = sprite_get_width(spr_bowl_base);
		var bw_h = sprite_get_height(spr_bowl_base);
		
		var left = bw.x - bw_w * 0.5;
		var right = bw.x + bw_w * 0.5;
		var top = bw.y - bw_h * 0.5;
		var bottom = bw.y + bw_h * 0.5;
		
		var mouse_over_bowl = 
			mx > left &&
			mx < right &&
			my > top &&
			my < bottom;
		
		if (mouse_over_bowl && obj_game.bowls.can_receive_egg(bw.bowl_index)) {
			obj_game.bowls.add_egg(bw.bowl_index, drag_egg_type);
			dropped = true;
			break;
		}
	}
	
	if (!dropped) {
		var egg_return = {
			type: drag_egg_type,
			sprite_frame: drag_egg_frame
		};
		array_push(station.caught_eggs, egg_return);
	}
	
	dragging_egg = false;
	drag_egg_index = -1;
	drag_egg_type = -1;
	drag_egg_frame = -1;
}