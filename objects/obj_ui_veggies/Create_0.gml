
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
block_exit = false;

obj_game.veggies.set_board_geometry(gui_w, gui_h);
obj_game.veggies.set_conveyor_geometry(gui_w, gui_h);
obj_game.veggies.set_trash_geometry(gui_w, gui_h);
obj_game.veggies.set_guide_geometry(gui_w, gui_h);
obj_game.bowls.set_drag_locked_for_station(STATION.VEGGIES, true);

// Bowls
var boffset_x = 15;
var boffset_y = 35;

bowls = [];
for (var i = 0; i < 3; i++) {
    var bx = 570 + boffset_x;
    var by = 150 + i * 60 + boffset_y;

    var bw = instance_create_layer(bx, by, "UI", obj_bowl_ui);

    bowls[i] = bw;

    bw.x_start = bx;
    bw.y_start = by;
	
	bw.bowl_index = i;
}