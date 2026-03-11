// Tabla
c_brown = #CCA57A

// Crear tabla
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

obj_game.noodles.set_board_geometry(gui_w, gui_h);

//botón ritual
var station = obj_game.noodles.noodle_station;
ritual_button_hover = false;

rbutton_x = station.board_x + station.board_w * 0.5 + 32;
rbutton_y = station.board_y;
rbutton_w = sprite_get_width(spr_nd_choose_ritual);
rbutton_h = sprite_get_height(spr_nd_choose_ritual);


// Selección ritual
ritual_symbols = [
	NOODLE_ID.WHEAT,
	NOODLE_ID.MUCUS,
	NOODLE_ID.STONE,
	NOODLE_ID.LEY,
	NOODLE_ID.CURSED
];

ritual_symbol_x = [];
ritual_symbol_y = [];
block_exit = false;

function update_ritual_select(_mx, _my) {

	var symbols = ritual_symbols;
	var spr = spr_nd_ritual_symbols;

	var w = sprite_get_width(spr);
	var h = sprite_get_height(spr);

	for (var i = 0; i < array_length(symbols); i++) {

		var rx = ritual_symbol_x[i];
		var ry = ritual_symbol_y[i];

		var mouse_over_symbol =
			_mx >= rx - w * 0.5 &&
			_mx <= rx + w * 0.5 &&
			_my >= ry - h * 0.5 &&
			_my <= ry + h * 0.5;

		if (mouse_over_symbol && mouse_check_button_pressed(mb_left)) {

			var type = symbols[i];
			obj_game.noodles.select_ritual(type);
			return;

		}
	}

	if (keyboard_check_pressed(vk_escape)) {
		obj_game.noodles.close_ritual_ui();
	}
}
	

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