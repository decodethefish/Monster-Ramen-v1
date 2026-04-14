var dt = delta_time / 1000000;

switch (state) {

    case CUSTOMER_STATE.SPAWN:
    case CUSTOMER_STATE.QUEUE:

    break;

    case CUSTOMER_STATE.WALK:

        var dist = point_distance(x, y, target_x, target_y);

        if (dist > 2) {
            var dir = point_direction(x, y, target_x, target_y);
            x += lengthdir_x(spd * dt, dir);
            y += lengthdir_y(spd * dt, dir);
        } else {

            // SOLO el cliente activo puede entrar a WAIT
            if (obj_game.customers.active_customer == id) {
                state = CUSTOMER_STATE.WAIT;
            } else {
                state = CUSTOMER_STATE.QUEUE;
            }
        }

    break;

    case CUSTOMER_STATE.WAIT:

        // Si deja de ser activo, vuelve a la cola
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