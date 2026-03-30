function MeatSystem() constructor {
	
	my_station = STATION.MEAT;
	is_passive = true;
	
	meats_data = [];
	active_meats = [];
	
	
	function init() {
		
		meats_data[MEAT_ID.BEEF] = {
			gravity: 4,
			lift: 5,
			tender_time: 6,
			cook_time: 60,
			cook_ready_time: 50,
		};
		
		meats_data[MEAT_ID.BUG] = {
			gravity: 4,
			lift: 7,
			tender_time: 1,
			cook_time: 35,
			cook_ready_time: 30,
		};
		
		meats_data[MEAT_ID.DRAGON] = {
			gravity: -4,
			lift: -6,
			tender_time: 10,
			cook_time: 45,
			cook_ready_time: 42,
		};
	
		meat_station = {
	
			available_meats: [
				MEAT_ID.BEEF,
				MEAT_ID.BUG,
				MEAT_ID.DRAGON
			],
			
			mode: MEAT_MODE.TENDER,
			
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
			
			tray_x :0,
			tray_y: 0,
			tray_w: 0,
			tray_h: 0,
			tray_meats: [],
			tray_max: 3,
			tray_has_meat: false,
			cook_tray_center_y: 0,
			
			grill_x: 0,
			grill_y: 0,
			grill_w: 0,
			grill_h: 0,
			grill_slots: [
				noone,
				noone
			],
			
			cook_b_x : 0,
		    cook_b_y : 0,
			cook_b_w : 0,
		    cook_b_h : 0,
			tender_b_x: 0,
			tender_b_y: 0,
			tender_b_w: 0,
			tender_b_h: 0,
			
			tender_value: 0,
			tender_dir: 1,
			tender_speed: 0.02,
			tender_running: false,
			
			tender_target: 0.5,
			tender_window: 0.15,
			
			tender_time_in_zone: 0,
			tender_goal: 5,
			
			tender_input: false,
			tender_segments: 6,
			tender_target_zone: obj_game.current_order.meat_target_tender,
			tender_current_zone: 0,
			tender_timer: 0,
			tender_time_required: 60,
		
		}
	}

	function start_meat(_type) {
		
		var s = meat_station;
		var data = meats_data[_type];
		
		s.has_meat = true;
		s.type = _type;

		s.state = MEAT_STATE.RAW;
		
		s.tender_value = 0;
		
		s.tender_running = false;
		s.tender_timer = data.tender_time;
		s.tender_progress = 0;
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
	
	function set_tray_geometry(_gui_w, _gui_h) {
		
		var s = meat_station;
		var w = sprite_get_width(spr_mt_tray);
		var h = sprite_get_height(spr_mt_tray);
		
		s.tray_w = w;
		s.tray_h = h
		
		s.tray_x = _gui_w - w * 0.5;
		s.tray_y = s.board_y;
		
	}

	function set_cook_button_geometry(_gui_w, _gui_h) {
		
		var s = meat_station
		var w = sprite_get_width(spr_mt_cook_button);
		var h = sprite_get_height(spr_mt_cook_button);
		
		s.cook_b_w = w;
		s.cook_b_h = h;
		
		s.cook_b_x = _gui_w - w * 0.5;
		s.cook_b_y = 0 + h * 0.5;

	}

	function set_tender_button_geometry(_gui_w, _gui_h) {
		
		var s = meat_station
		var w = sprite_get_width(spr_mt_tender_button);
		var h = sprite_get_height(spr_mt_tender_button);
		
		s.tender_b_w = w;
		s.tender_b_h = h;
		
		s.tender_b_x = 0 + w * 0.5;
		s.tender_b_y = 0 + h * 0.5;

	}
		
	function set_cook_tray_geometry(_gui_h) {
	
		var s = meat_station;
		var tray = s.tray_meats;
		var count = array_length(tray);
		
		var result = [];
		
		s.cook_tray_center_y = _gui_h * 0.5 + 25;
		
		if (count == 0) return result;
		
		var base_x = 80;
		var center_y = _gui_h * 0.5;
		
		var meat_h = sprite_get_height(spr_mt_meat_ready_cook);
		var spacing = meat_h * 0.8;
		
		var total_h = (count - 1) * spacing;
		var start_y = center_y - total_h * 0.5;
		
		
		for (var i = 0; i < count; i++) {
		
			var yy = start_y + i * spacing;
			
	        result[i] = {
	            rx: base_x,
	            ry: yy,
	            left: base_x - sprite_get_width(spr_mt_meat_ready_cook) * 0.5,
	            right: base_x + sprite_get_width(spr_mt_meat_ready_cook) * 0.5,
	            top: yy - meat_h * 0.5,
	            bottom: yy + meat_h * 0.5
			};
		}
		
		return result;
	
	}

	function set_grill_geometry(_gui_w, _gui_h) {
		
		var s = meat_station
		var w = sprite_get_width(spr_mt_grill);
		var h = sprite_get_height(spr_mt_grill);
		
		s.grill_w = w;
		s.grill_h = h;
		
		s.grill_x = _gui_w * 0.5;
		s.grill_y = _gui_h * 0.5;

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
		
		var s = meat_station;
		
		update_tender(_dt);
		update_cook(_dt);
		
	}
	
	function update_tender(_dt) {
	
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
		
		if (zone == s.tender_target_zone) {
			s.tender_time_in_zone += _dt;
		}
		
		s.tender_timer -= _dt;
		s.tender_timer = max(0, s.tender_timer);
		
		if (s.tender_timer <= 0) {
			
			s.tender_running = false;
			s.state = MEAT_STATE.READY_FOR_GRILL;
			s.hammer_picked = false;
		
		}
	}
		
	function update_cook(_dt) {

	    var s = meat_station;
	    var grill = s.grill_slots;

	    for (var i = 0; i < array_length(grill); i++) {

	        var mt = grill[i];
	        if (mt == noone) continue;

	        var data = meats_data[mt.type];

	        mt.cook_time += _dt;

	        var t = mt.cook_time;
	        var ready = data.cook_ready_time;
	        var t_end = data.cook_time;
			
			mt.is_burned = (t > t_end);
	        mt.in_window = (t >= ready && t <= t_end);
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
	
	function get_meat_final_quality(_meat) {
	
		var data = meats_data[_meat.type];
		
		var t = _meat.cook_time;
		var ready = data.cook_ready_time;
		var end_t = data.cook_time;
		
		var cook_quality;
		
		if (t < ready) {
			cook_quality = 1; // cruda
		}
		else if (t <= end_t) {
			cook_quality = 3; // perfecta
		}
		else {
			cook_quality = 0; // quemada
		}
		
		var final_quality = floor((_meat.tender_quality + cook_quality) * 0.5);
		return final_quality;
	}
	
	function end_tender() {
	
		var s = meat_station;
		var data = meats_data[s.type];
		
		var total_time = data.tender_time;
		var time_in_zone = s.tender_time_in_zone;
		var margin = 0.5;
		
		var effective_time = max(0, time_in_zone - margin);
		
		var q = effective_time / total_time;
		q = clamp(q, 0, 1);
		
		
		var tender_quality;
		
		if (q >= 0.7) {
			tender_quality = 3; // HIGH
		}
		else if (q >= 0.4) {
			tender_quality = 2; // MID
		}
		else {
			tender_quality = 1; // LOW	
		}
		
		s.tender_running = false;
		s.state = MEAT_STATE.READY_FOR_GRILL;
		
	    return {
	        type: s.type,
	        tender_quality: tender_quality
	    };
	}
	
	function reset() {
	
		var s = meat_station;
		
		s.has_meat = false;
		s.type = MEAT_ID.NONE;
		s.state = MEAT_STATE.RAW;
		s.mode = MEAT_MODE.TENDER;
		s.tender_value = 0;
		s.tender_running = false;
		s.tender_timer = 0;
		s.tender_time_in_zone = 0;
		s.tender_current_zone = 0;
		s.hammer_picked = false;

	}

}