function MeatSystem() constructor{
	
	my_station = STATION.MEAT;
	is_passive = true;
	
	meats_data = [];
	active_meats = [];

	function init() {
		
		meats_data[MEAT_ID.BEEF] = {
			gravity: 2,
			lift: 3,
			tender_time: 120,
			cook_time: 100
		};
		
		meats_data[MEAT_ID.BUG] = {
			gravity: 4,
			lift: 5,
			tender_time: 100,
			cook_time: 100
		};
		
		meats_data[MEAT_ID.DRAGON] = {
			gravity: -2,
			lift: -3,
			tender_time: 120,
			cook_time: 100
		};
	
		meat_station = {
	
			available_meats: [
				MEAT_ID.BEEF,
				MEAT_ID.BUG,
				MEAT_ID.DRAGON
			],
			
		    board_x : 0,
		    board_y : 0,
			board_w : 0,
		    board_h : 0,
			selector_spacing: 20,
			selector_y: 44,
		
			has_meat: false,
			type: MEAT_ID.NONE,
			state: MEAT_STATE.RAW,
			
			hammer_picked: false,
			hammer_x: 0,
			hammer_y: 0,
			hammer_w: 0,
			hammer_h: 0,
			hammer_offset_x : 0,
			hammer_offset_y : 0,
			hammer_angle: 0,
			hammer_frame: 0,
			hammer_home_x: 0,
			hammer_home_y: 0,
			
			tender_value: 0,
			tender_dir: 1,
			tender_speed: 0.02,
			tender_running: false,
			
			tender_target: 0.5,
			tender_window: 0.15,
			
			tender_progress: 0,
			tender_goal: 5,
			
			tender_input: false,
			tender_segments: 6,
			tender_target_zone: 2,
			tender_current_zone: 0,
			tender_timer: 0,
			tender_time_required: 60,
		
		}
	}
	
	function set_board_geometry(_gui_w, _gui_h) {
		
		var s = meat_station
		var w = sprite_get_width(spr_mt_board);
		var h = sprite_get_height(spr_mt_board);
		
		s.board_w = w;
		s.board_h = h;
		
		s.board_x = _gui_w * 0.5;
		s.board_y = _gui_h - h * 0.5 - 5;

	}
	
	function set_hammer_geometry(_gui_w, _gui_h) {
		
		var station = meat_station
		var home_w = sprite_get_width(spr_mt_hammer_home);
		var home_h = sprite_get_height(spr_mt_hammer_home);
		
		station.hammer_home_w = home_w;
		station.hammer_home_h = home_h;
		
		station.hammer_w = sprite_get_width(spr_mt_hammer);
		station.hammer_h = sprite_get_height(spr_mt_hammer);
		
		station.hammer_home_x = home_w * 0.5;
		station.hammer_home_y = station.board_y;
		
	}
	
	function should_update(_current_station) {
		return is_passive || _current_station == my_station;	
	}
	
	function try_start_tender() {
		
		var s = meat_station;
		
		if (s.state != MEAT_STATE.RAW) return;
		if (!s.has_meat) return;
		
		s.state = MEAT_STATE.TENDER;
		
		s.tender_value = 5;
		s.tender_dir = 1;
		s.tender_progress = 0;
	}
	
	function update(_dt) {
	
		update_tender();
	
	}
	
	function update_tender() {
	
		var s = meat_station;
		var data = meats_data[s.type]
		
		if (s.state != MEAT_STATE.TENDER) return;
		if (!s.tender_running) return;
	
		
		s.tender_value += data.gravity * 0.05;
		
		if (s.tender_input) {
			s.tender_value -= data.lift * 0.05;
		}

		s.tender_value = clamp(s.tender_value, 0, 10);		
		
		var zone = get_tender_zone();
		s.tender_current_zone = zone;
		
		if (s.tender_current_zone == s.tender_target_zone) {
			s.tender_timer += 1;
		}
	}
	
	function hit_tender() {
	
		var s = meat_station;
		
		if (s.state != MEAT_STATE.TENDER) return;
		
		if (!s.tender_running) {
			s.tender_running = true;
			return;
		}
	}
		
	function get_tender_zone() {
		
		var s = meat_station;
		var zone = floor((s.tender_value / 10) * s.tender_segments);
		
		return clamp(zone, 0, s.tender_segments -1);
	}
	
	function start_meat(_type) {
		
		var s = meat_station;
		
		s.has_meat = true;
		s.type = _type;

		s.state = MEAT_STATE.RAW;
		s.tender_value = 0;
		s.tender_dir = 1;
		s.tender_running = false;
		s.tender_timer = 0;
		s.tender_progress = 0;
	}
	
	
	
}