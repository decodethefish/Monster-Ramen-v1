dragging_raw = false;
dragging_ready = false;
dragging_cook = false;
drag_meat_id = MEAT_ID.NONE;

dragging_cook = false;
drag_meat = -1;
mouseover_cook_index = -1;
dragging_grill = false;
drag_grill_index = -1;

obj_game.bowls.set_drag_locked_for_station(STATION.MEAT, true);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

c_brown = #B27859;
obj_game.meat.set_board_geometry(gui_w, gui_h);
obj_game.meat.set_hammer_geometry(gui_w, gui_h);
obj_game.meat.set_tray_geometry(gui_w, gui_h);
obj_game.meat.set_cook_button_geometry(gui_w, gui_h);
obj_game.meat.set_tender_button_geometry(gui_w, gui_h);
obj_game.meat.set_grill_geometry(gui_w, gui_h);


// obteniendo posiciones de carnes
function get_meat_layout(_x_center, _y, _meats, _spacing) {
	
	var count = array_length(_meats);
	var sprite_w = sprite_get_width(spr_mt_meats);
	var sprite_h = sprite_get_height(spr_mt_meats);
	
	var total_width = count * sprite_w + (count - 1) * _spacing;
	var start_x = _x_center - total_width / 2 + sprite_w * 0.5;
	
	var result = [];
	
	for (var i = 0; i < count; i++) {
		
		var cx = start_x + i * (sprite_w + _spacing);
		
		result[i] = {
			x: cx,
			y: _y,
			left: cx - sprite_w * 0.5,
			right: cx + sprite_w * 0.5,
			top: _y - sprite_h * 0.5,
			bottom: _y + sprite_h * 0.5
		}
	}
	
	return result;
}
	
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