// Tabla
c_brown = #CCA57A

// Crear tabla

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

obj_game.noodles.set_board_geometry(gui_w, gui_h);


// Masas

dough = []
var d;

d = {
	x_start: 77,
	y_start: 45,
	x: 77,
	y: 45,
	sprite: spr_nd_dough,
	recipe_id: NOODLE_ID.WHEAT,
	dragging: false
};
array_push(dough, d);	

d = {
	x_start: 190,
	y_start: 45,
	x: 190,
	y: 45,
	sprite: spr_nd_dough_mucus,
	recipe_id: NOODLE_ID.MUCUS,
	dragging: false
};
array_push(dough, d);	

d = {
	x_start: 303,
	y_start: 45,
	x: 303,
	y: 45,
	sprite: spr_nd_dough_ley,
	recipe_id: NOODLE_ID.LEY,
	dragging: false
};
array_push(dough, d);	

d = {
	x_start: 416,
	y_start: 45,
	x: 416,
	y: 45,
	sprite: spr_nd_dough_cursed,
	recipe_id: NOODLE_ID.CURSED,
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