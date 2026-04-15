if (obj_game.game_mode != GAME_MODE.COOKING) exit;

if (!dialog_done) {

	if (keyboard_check_pressed(vk_space)) {
	
		dialog_index++;
		
		if (dialog_index >= array_length(dialog_lines)) {

		    dialog_done = true;

		    if (instance_exists(customer)) {

		        var order = obj_game.customers.generate_order();

		        customer.order = order;
			
		        obj_game.current_order = order;
				obj_game.meat.set_order(order);
				obj_game.order_system.set_order(order);
				obj_game.noodles.set_order(order);
				
				show_debug_message("==== ORDER ====");

				show_debug_message("NOODLES: " 
				    + noodle_to_string(order.noodles.type) 
				    + " | cm: " + string(order.noodles.target_cm)
				);

				show_debug_message("BROTH: " 
				    + broth_to_string(order.broth)
				);

				show_debug_message("MEAT: " 
				    + meat_to_string(order.meat.type) 
				    + " | target: " + string(order.meat.target_tender)
				);

				show_debug_message("EGG: " 
				    + egg_to_string(order.egg)
				);

				show_debug_message("VEGGIE: " 
				    + veggie_to_string(order.veggies.type)
				    + " | result: " + veggie_result_to_string(order.veggies.result)
				);
				
		        customer.state = CUSTOMER_STATE.WALK;
		        customer.locked = false;
				
				customer.has_order = true;
				
				var w_spot = instance_find(obj_wait_spot, 0);
				if (w_spot != noone) {
					customer.target_x = w_spot.x;
					customer.target_y = w_spot.y
				}
				
				if (obj_game.customers.active_customer == customer) {
					obj_game.customers.active_customer = noone;	
				}
				
		    }

		    obj_game.close_station();
		}
	}
}