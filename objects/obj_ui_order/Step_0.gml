if (obj_game.game_mode != GAME_MODE.COOKING) exit;

if (!instance_exists(customer)) exit;

if (!dialog_done) {

	if (keyboard_check_pressed(vk_space))	{
		
		dialog_index++;
		
		if (dialog_index >= array_length(dialog_lines)) {
		
			dialog_done = true;
			
			obj_game.customers.finish_interaction(customer);
			
			obj_game.close_station();
		}
	}
}