// Tabla
c_brown = #CCA57A

// Crear tabla
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

obj_game.noodles.set_board_geometry(gui_w, gui_h);

// Guías
guide_active = false;
guide_x = 0;

// Masa unica
dough = [];
var d = {
	x_start: 77,
	y_start: 45,
	x: 77,
	y: 45,
	sprite: spr_nd_dough,
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