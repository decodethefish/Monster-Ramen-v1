dragging = false;
just_released = false;
x_start = x;
y_start = y;
bowl_index = -1;

<<<<<<< Updated upstream
sprite_index = spr_bowl_base;
image_speed = 0;
image_index = 0;
=======
if (!variable_global_exists("bowl_drag_active")) {
	global.bowl_drag_active = false;
}
>>>>>>> Stashed changes
