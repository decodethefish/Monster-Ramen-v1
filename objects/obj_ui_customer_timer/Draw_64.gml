if (!instance_exists(obj_game)) exit;
if (is_undefined(obj_game.customers)) exit;

var timers = obj_game.customers.get_ui_timers();
var count = array_length(timers);
if (count <= 0) exit;

var tx = margin_x;
var ty = margin_y;

draw_set_font(label_font);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);

for (var i = 0; i < count; i++) {
	var timer = timers[i];
	var ratio = timer.ratio;
	
	var color = c_red;
	if (ratio > 0.66) {
		color = c_lime;
	} else if (ratio > 0.33) {
		color = c_yellow;
	}

	var label = "CLIENTE " + string(i + 1);
	
	draw_set_colour(c_white);
	draw_text(x, ty + bar_height * 0.5, label);
	
	var label_w = string_width(label);
	var bx = tx + label_w + 8;
	var by = ty;
	
	draw_set_alpha(0.45);
	draw_set_colour(c_dkgray);
	draw_rectangle(bx, by, bx + bar_width, by + bar_height, false);
	
	draw_set_alpha(1);
	draw_set_colour(color);
	draw_rectangle(bx, by, bx + bar_width * ratio, by + bar_height, false);
	
	draw_set_colour(c_black);
	draw_rectangle(bx, by, bx + bar_width, by + bar_height, true);

	y += bar_height + row_gap;
}

draw_set_alpha(1);
draw_set_colour(c_white);
