if (obj_game.game_mode != GAME_MODE.COOKING) exit;

if (interaction == noone) exit;

if (!interaction.done) {

    if (keyboard_check_pressed(vk_space)) {

        interaction.dialog_index++;

        if (interaction.dialog_index >= array_length(interaction.dialog_lines)) {

            interaction.done = true;

            obj_game.customers.finish_interaction();

            obj_game.close_station();
        }
    }
}