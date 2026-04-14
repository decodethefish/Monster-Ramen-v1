var dt = delta_time / 1000000;

switch (state) {

    case CUSTOMER_STATE.SPAWN:
        state = CUSTOMER_STATE.WALK;
    break;

    case CUSTOMER_STATE.WALK:

        var dist = point_distance(x, y, target_x, target_y);

        if (dist > 2) {
            var dir = point_direction(x, y, target_x, target_y);
            x += lengthdir_x(spd * dt, dir);
            y += lengthdir_y(spd * dt, dir);
        } else {
            state = CUSTOMER_STATE.WAIT;
        }

    break;

    case CUSTOMER_STATE.WAIT:

        if (!locked) {
            wait_timer -= dt;

            if (wait_timer <= 0) {
                state = CUSTOMER_STATE.LEAVE;
            }
        }

    break;

    case CUSTOMER_STATE.INTERACT:
    break;

    case CUSTOMER_STATE.DONE:
        state = CUSTOMER_STATE.LEAVE;
    break;

    case CUSTOMER_STATE.LEAVE:
        x -= spd * dt;
    break;
}
	
