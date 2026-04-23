if (obj_game.game_mode != GAME_MODE.COOKING) exit;
if (interaction == noone) exit;

// avanzar diálogo
if (!interaction.done) {

	if (keyboard_check_pressed(vk_space)) {

		interaction.dialog_index++;

		if (interaction.dialog_index >= array_length(interaction.dialog_lines)) {
			interaction.done = true;
		}
	}
	return;
}

// generar orden 
if (!order_generated) {
	order_generated = true;
	obj_game.customers.finish_interaction();
	return;
}

// cerrar UI en siguiente input
if (keyboard_check_pressed(vk_space)) {
	obj_game.close_station();
}