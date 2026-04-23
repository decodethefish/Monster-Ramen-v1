var dt = delta_time / 1000000;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

switch (state) {

    case CUSTOMER_STATE.SPAWN:
	
    case CUSTOMER_STATE.QUEUE:
		
		var dist = point_distance(x, y, target_x, target_y);
		
		if (dist > 2) {
			var dir = point_direction(x, y, target_x, target_y);
			x += lengthdir_x(spd * dt, dir);
			y += lengthdir_y(spd * dt, dir);
		}
		
    break;

    case CUSTOMER_STATE.WALK:

        var dist = point_distance(x, y, target_x, target_y);

        if (dist > 2) {
			
            var dir = point_direction(x, y, target_x, target_y);
            x += lengthdir_x(spd * dt, dir);
            y += lengthdir_y(spd * dt, dir);
			
        } else {
			
			if (has_order) {
				
				state = CUSTOMER_STATE.WAIT_FOOD;	
				food_wait_timer = 180;
				
			}
			else if  (obj_game.customers.active_customer == id) {
					state = CUSTOMER_STATE.WAIT;
			}
			else {
				state = CUSTOMER_STATE.QUEUE;	
			}
		}

    break;

    case CUSTOMER_STATE.WAIT:

        if (obj_game.customers.active_customer != id) {
            state = CUSTOMER_STATE.QUEUE;
            break;
        }

        if (!locked) {
            wait_timer -= dt;

            if (wait_timer <= 0) {
                state = CUSTOMER_STATE.LEAVE;
            }
        }

    break;
	
    case CUSTOMER_STATE.WAIT_FOOD:
        
		var dist = point_distance(x, y, target_x, target_y);
		
		if (dist > 2) {
			
			var dir = point_direction(x, y, target_x, target_y);
			x += lengthdir_x(spd * dt, dir);
			y += lengthdir_y(spd * dt, dir);
			
		}
		
		food_wait_timer -= dt;
		
		if (food_wait_timer <= 0) {
			if (has_order) {
				obj_game.customers.remove_ticket_for_customer(id);
				has_order = false;
			}
			
			state = CUSTOMER_STATE.LEAVE;	
			locked = false;
			
			target_x = x;
			target_y = room_height + 100;
			
		}
		
    break;
	
    case CUSTOMER_STATE.INTERACT:
        // quieto
    break;

    case CUSTOMER_STATE.DONE:
        state = CUSTOMER_STATE.LEAVE;
    break;

    case CUSTOMER_STATE.LEAVE:
        y += spd * dt;
    break;
}

// Review entregar bowl
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