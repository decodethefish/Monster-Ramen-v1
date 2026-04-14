if (obj_game.game_mode != GAME_MODE.WORLD) exit;

if (place_meeting(x, y, obj_player)) {

    if (keyboard_check_pressed(ord("E"))) {

        var c = obj_game.customers.get_active_customer();

        if (obj_game.customers.start_interaction(c)) {

            obj_game.current_customer = c;
            obj_game.request_open_station(STATION.ORDER);
        }
    }
}