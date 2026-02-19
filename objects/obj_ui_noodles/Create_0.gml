// Tabla
c_brown = #CCA57A

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height()

board_w = sprite_get_width(spr_noodle_board);
board_h = sprite_get_height(spr_noodle_board);
board_x = gui_w * 0.07 + board_w * 0.5;
board_y = gui_h * 0.25 + board_h * 0.5;



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


// Bowls

bowls = [];

for (var i = 0; i < 3; i++) {
    var bx = 570;
    var by = 120 + i * 60;

    var bw = instance_create_layer(bx, by, "UI", obj_bowl_ui);

    bowls[i] = bw;

    bw.x_start = bx;
    bw.y_start = by;
	
	bw.bowl_index = i;
}