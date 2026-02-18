// Tabla
c_brown = #CCA57A

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height()

board_x = gui_w * 0.07;
board_y = gui_h * 0.25;
board_w = gui_w * 0.70;
board_h = gui_h - board_y;


// Masas

dough = []
var d;

d = {
	x_start: 77,
	y_start: 45,
	x: 77,
	y: 45,
	sprite: spr_dough,
	recipe_id: NOODLE_ID.WHEAT,
	dragging: false
};
array_push(dough, d);	

d = {
	x_start: 190,
	y_start: 45,
	x: 190,
	y: 45,
	sprite: spr_dough_mucus,
	recipe_id: NOODLE_ID.MUCUS,
	dragging: false
};
array_push(dough, d);	


// Sheet de masa

gap = 24;

sheet_w = 400;
sheet_h = board_h - gap * 2;

sheet_x = board_x + gap;
sheet_y = board_y + gap;

