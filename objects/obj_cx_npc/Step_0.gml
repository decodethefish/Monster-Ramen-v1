var dt = delta_time / 1000000;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

switch (state) {

    case CUSTOMER_STATE.WAIT_FOOD:
		var dist = point_distance(x, y, target_x, target_y);
		if (dist > 2) {
			var dir = point_distance(x, y, target_x, target_y)	;;
			x += lengthdir_x(spr * dt, dir);
			y += lengthdir_y(spr * dt, dir);
		}
	break;

    case CUSTOMER_STATE.LEAVE:
        y += spd * dt;
    break;
	
}

// Entrar a review
if (state == CUSTOMER_STATE.WAIT_FOOD) {

	var player = instance_find(obj_player, 0);
	if (player != noone) {
		
		var touching_player = place_meeting(x, y, obj_player);

		var mouse_over = point_in_rectangle(
			mx, my,
			bbox_left, bbox_top,
			bbox_right, bbox_bottom
		);

		if (touching_player) {

		    // teclado
		    if (keyboard_check_pressed(ord("E"))) {
		        obj_game.customers.try_open_review(id);
		    }

		    // mouse
		    if (mouse_over && mouse_check_button_pressed(mb_left)) {
		        obj_game.customers.try_open_review(id);
		    }
		}
	}
}