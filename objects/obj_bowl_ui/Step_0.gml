var data = obj_game.bowls.bowls[bowl_index];


obj_game.bowls.draw(bowl_index, x, y);

var left = x - sprite_width * 0.5
var right = x + sprite_width * 0.5
var top = y - sprite_height * 0.5
var bottom = y + sprite_height * 0.5

var mouse_over = 
	mouse_x >= left && mouse_x <= right &&
	mouse_y >= top && mouse_y <= bottom;
	
// drag & drop

if (mouse_over && mouse_check_button_pressed(mb_left)) {
	dragging = true;
}
if (dragging) {
	x = mouse_x;
	y = mouse_y;
}
if (dragging && mouse_check_button_released(mb_left)) {
	
	dragging = false;
	
	var pot_index = obj_game.broth.get_pot_at_position(x, y);
	
	if (obj_game.bowls.can_receive_broth(bowl_index)) {
		obj_game.bowls.add_broth(
			bowl_index,
			pot_index,
			obj_game.broth.pots
		);
	}
	
	x = x_start;
	y = y_start;
	
}
	