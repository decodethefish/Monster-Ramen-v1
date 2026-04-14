if (obj_game.game_mode != GAME_MODE.COOKING) exit;

if (!dialog_done) {

	if (keyboard_check(vk_space)) {
	
		dialog_index++;
		
		if (dialog_index > array_length(dialog_lines)) {
			
			dialog_done = true;
			
			obj_game.customers.confirm_order(customer);
			
			obj_game.close_station();
		
		}
	}
}