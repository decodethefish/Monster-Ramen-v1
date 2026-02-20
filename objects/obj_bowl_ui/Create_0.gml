dragging = false;
just_released = false;
x_start = x;
y_start = y;
bowl_index = -1;

if (!variable_global_exists("bowl_drag_active")) {
	global.bowl_drag_active = false;
}