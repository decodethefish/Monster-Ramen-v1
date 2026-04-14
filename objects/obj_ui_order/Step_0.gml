if (obj_game.game_mode != GAME_MODE.COOKING) exit;

if (!dialog_done) {

	if (keyboard_check_pressed(vk_space)) {
	
		dialog_index++;
		
		if (dialog_index > array_length(dialog_lines)) {

		    dialog_done = true;

		    if (instance_exists(customer)) {

		        var order = obj_game.customers.generate_order();

		        customer.order = order;

		        obj_game.current_order = order;
				obj_game.meat.set_order(order);

		        customer.state = CUSTOMER_STATE.WAIT;
		        customer.locked = false;
		    }

		    obj_game.close_station();
		}
	}
}