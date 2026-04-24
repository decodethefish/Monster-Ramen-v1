if (obj_game.game_mode != GAME_MODE.COOKING) exit;
if (interaction == noone) exit;

// avanzar diálogo
if (!interaction.done) {
	if (keyboard_check_pressed(vk_space)) {
		interaction.dialog_index++;
		if (interaction.dialog_index >= array_length(interaction.dialog_lines)) interaction.done = true;
	}
	return;
}

// mostrar ticket de orden
if (!order_generated) {
    order_generated = true;

    var preview_order = interaction.preview_order;
    if (is_undefined(preview_order)) {
        var c = interaction.customer;
        if (instance_exists(c)) preview_order = c.pending_order;
    }

    if (!is_undefined(preview_order)) {
        obj_game.orders.begin_preview(preview_order, interaction.customer);
    }
    return;
}

// cerrar UI y terminar interacción al siguiente input
if (keyboard_check_pressed(vk_space)) {
	obj_game.customers.finish_interaction();
	obj_game.close_station();
}