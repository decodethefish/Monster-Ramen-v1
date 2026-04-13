var state = obj_game.get_cooking_state();

// Bump al cambiar de estado
if (state != eye_last_state) {
	eye_bump_scale = 1.25;
	eye_last_state = state;
}

eye_bump_scale = lerp(eye_bump_scale, 1, 0.2);
eye_scale = lerp(eye_scale, eye_bump_scale, 0.4);

// Cambio de frame
image_index = state;