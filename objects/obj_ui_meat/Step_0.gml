var station = obj_game.meat.meat_station;
var meats = station.available_meats;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var layout = get_meat_layout ( 
	display_get_gui_width()/2,
	station.selector_y,
	meats,
	station.selector_spacing
);

var mleft   = station.board_x - station.board_w * 0.5;
var mright  = station.board_x + station.board_w * 0.5;
var mtop    = station.board_y - station.board_h * 0.5;
var mbottom = station.board_y + station.board_h * 0.5;

var mouse_over_board = (mx >= mleft && mx <= mright && my >= mtop && my <= mbottom);

// mouse over carnes
mouse_over_index = -1;
for (var i = 0; i < array_length(layout); i++) {
	
	var r = layout[i];
	
    if (mx >= r.left && mx <= r.right && my >= r.top && my <= r.bottom) {
        mouse_over_index = i;
	}
}

// drag carnes
if (!dragging_raw && !station.hammer_picked && mouse_over_index != -1 && mouse_check_button_pressed(mb_left)) {
	dragging_raw = true;
	drag_meat_id = meats[mouse_over_index];
}
if (dragging_raw && mouse_check_button_released(mb_left)) {
	
	dragging_raw = false;
	
	if (mouse_over_board) {
		obj_game.meat.start_meat(drag_meat_id);
	}
}

// Mazo
var hleft   = station.hammer_home_x - station.hammer_home_w * 0.5;
var hright  = station.hammer_home_x + station.hammer_home_w * 0.5;
var htop    = station.hammer_home_y - station.hammer_home_h * 0.5;
var hbottom = station.hammer_home_y + station.hammer_home_h * 0.5;

var mouse_over_home = (mx >= hleft && mx <= hright && my >= htop && my <= hbottom);

if (mouse_check_button_pressed(mb_left)) {

	if (!station.hammer_picked && mouse_over_home && !dragging_raw) {
		station.hammer_picked = true;
		station.hammer_offset_x = 0;
		station.hammer_offset_y = 40;
	}
	
	else if (station.hammer_picked && mouse_over_home) {
		station.hammer_picked = false;
		station.tender_active = false;	
		station.state = MEAT_STATE.RAW;
	}
}

// golpe martillo
if (station.hammer_picked && station.has_meat && mouse_over_board && mouse_check_button_pressed(mb_left)) {
    station.hammer_frame = 1;
	obj_game.meat.hit_tender();
}
station.tender_input = (mouse_check_button(mb_left) && station.tender_running && station.hammer_picked && mouse_over_board);

if (station.hammer_frame == 1 && mouse_check_button_released(mb_left)) {
    station.hammer_frame = 0;
}
	
// inicio tender
if (station.hammer_picked && station.has_meat && station.state == MEAT_STATE.RAW) {
	obj_game.meat.try_start_tender();
}
