var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var arr = obj_game.tickets.tickets;

hover_index = -1;

var center_x = display_get_gui_width() * 0.5;

// contar tickets
var count = 0;
for (var i = 0; i < array_length(arr); i++) {
	if (arr[i] != noone) count++;
}

// base centrada
var start_x = center_x - (count - 1) * spacing * 0.5;

// hover usando mismas posiciones que draw
var draw_i = 0;

for (var i = 0; i < array_length(arr); i++) {

	var t = arr[i];
	if (t == noone) continue;

	var tx = start_x + draw_i * spacing;
	var ty = y_anchor;

	var w = sprite_get_width(spr_tk_stations);
	var h = sprite_get_height(spr_tk_stations);

	var over =
		mx >= tx - w * 0.5 && mx <= tx + w * 0.5 &&
		my >= ty - h * 0.5 && my <= ty + h * 0.5;

	if (over) {
		hover_index = draw_i;
	}
	draw_i++;
}

// Animación ticket grande
if (hover_index != preview_index) {

	preview_index = hover_index;
	
	if (hover_index != -1) {
		preview_offset = -30;
		preview_active = true;	
	}
}
if (preview_active) {
	
	preview_offset = lerp(preview_offset, 0, 0.30);
	
	if (abs(preview_offset) < 0.5) {
		preview_offset = 0;
		preview_active = false;
	}
}




