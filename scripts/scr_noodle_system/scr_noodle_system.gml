function NoodleSystem() constructor {
	
	noodle_data = [];
	noodle_station = [];
	move_profile = [];

	
	function set_board_geometry(_gui_w, _gui_h) {
		
		noodle_station.board_w = sprite_get_width(spr_nd_board);
		noodle_station.board_h = sprite_get_height(spr_nd_board);
		
		noodle_station.board_x = round(_gui_w * 0.07 + noodle_station.board_w * 0.5);
		noodle_station.board_y = round(_gui_h * 0.25 + noodle_station.board_h * 0.5);

	}
	
	function init() {
		
		noodle_data[NOODLE_ID.NONE] = {
			name: "None",
			move_profile_id: 0,
		};
		noodle_data[NOODLE_ID.WHEAT] = {
			name: "Wheat Noodles",
			move_profile_id: 0,
		};
		noodle_data[NOODLE_ID.MUCUS] = {
			name: "Mucus Noodles",
			move_profile_id: 1,
		};
		noodle_data[NOODLE_ID.LEY] = {
			name: "Ley Noodles",
			move_profile_id: 2,
		};
		noodle_data[NOODLE_ID.CURSED] = {
			name: "Cursed Noodles",
			move_profile_id: 3,
		};
		
		
		noodle_station = {
			
			has_sheet: false,
			type: NOODLE_ID.NONE,
			target_cm: 5,
			cuts: [],
			quality: 0,
			state: NOODLE_STATE.NO_SHEET,
			
			sheet_x: 0,
			sheet_y: 0,
			
			board_x: 0,
			board_y: 0,
			board_w: 0,
			board_h: 0,
			
			move_lock_timer : 0,
			move_target_x : 0,
			move_profile_id : 0,
			move_state : NOODLE_MOVE_STATE.IDLE,
			move_timer : 0,
			move_cooldown : 0,
			move_count : 0,
			drift_dir : 1,
			drift_speed : 0,
			drift_pause_timer : 0,
			
			warning_glow : 0,
			warning_offset_x : 0,
			fake_count : 0,
			is_fake : false
		
		};
		
		

		move_profile[0] = {
			mspeed : 0,
			distance : 0,
			frequecy : 0,
			max_moves : 0,
			can_fake : false,
			cooldown_min : 0,
			cooldown_max : 0
		};
		move_profile[1] = {
			mspeed : 220,
			distance : 25,
			frequecy : 0.7,
			max_moves : 15,
			can_fake : true,
			cooldown_min : 0.5,
			cooldown_max : 2.0
		};		
		move_profile[2] = {
			mspeed : 240,
			distance : 25,
			frequecy : 0.5,
			max_moves : 10,
			can_fake : true,
			cooldown_min : 0.5,
			cooldown_max : 2.5
		};	
		move_profile[3] = {
			mspeed : 280,
			distance : 25,
			frequecy : 0.8,
			max_moves : 666,
			can_fake : false,
			cooldown_min : 0.5,
			cooldown_max : 1.0
		};	
	}
		
	function start_sheet(_type, _target_cm) {
		if (_type == NOODLE_ID.NONE) return;
		if (_target_cm <= 0) return;
		
		var data = noodle_data[_type];
		
		noodle_station.sheet_x = noodle_station.board_x;
		noodle_station.sheet_y = noodle_station.board_y;
		noodle_station.has_sheet = true;
		noodle_station.type = _type;
		noodle_station.target_cm = _target_cm;
		noodle_station.cuts = [];
		noodle_station.state = NOODLE_STATE.ACTIVE;
		
		noodle_station.move_profile_id = data.move_profile_id
		noodle_station.move_state = NOODLE_MOVE_STATE.IDLE;
		noodle_station.move_timer = 0;
		noodle_station.move_cooldown = 0;
		noodle_station.move_count = 0;
		noodle_station.fake_count = 0;
		noodle_station.is_fake = false;
		noodle_station.move_lock_timer = 0.5;
		if (_type == NOODLE_ID.LEY) {
			noodle_station.drift_dir = choose(-1, 1);
			noodle_station.drift_speed = random_range(8, 10);
		}
		
	}
	
	function add_cut(_cm) {
		if (!noodle_station.has_sheet) return;
		if (noodle_station.state != NOODLE_STATE.ACTIVE) return;
	
		array_push(noodle_station.cuts, _cm);

	}
	
	function calculate_quality() {
		
		if (!noodle_station.has_sheet) return 0;
		
		var cut_count = array_length(noodle_station.cuts);
		if (cut_count == 0) return 0;
		
		var target = noodle_station.target_cm;
		var sheet_lenght = 10;
		
		var prev = 0;
		var total_error = 0;
		
		for (var i = 0; i < cut_count; i++) {
		
			var current = noodle_station.cuts[i];
			var segment = current - prev;
			total_error += abs(segment - target);
			prev = current;
		}
		
		// ultimo segmento
		var last_segment = sheet_lenght - prev;
		total_error += abs(last_segment - target);
	
		// normalizar error - calidad
		var segments = sheet_lenght / target;
		var max_error_per_segment = 1;
		var max_error = segments * max_error_per_segment;
	
		var quality = 1 - (total_error / max_error);
		quality = clamp(quality,0,1);
		
		return quality;
	}
		
	function can_serve() {
		return noodle_station.has_sheet && array_length(noodle_station.cuts) >= 1;
	}
	
	function get_result() {
		
	    return { 
			noodle_id: noodle_station.type,
	        quality: calculate_quality()
	    };
	}

	function update(_dt) {
		update_movement(_dt);
		update_drift(_dt);
	}
		
	function update_drift(_dt) {
		
		var ns = noodle_station;
		
		if (!ns.has_sheet) return;
		if (ns.type != NOODLE_ID.LEY) return;
		
		var half_w = ns.board_w * 0.5;
		var sheet_half = sprite_get_width(spr_nd_sheet) * 0.5;
		var min_x = ns.board_x - half_w + sheet_half;
		var max_x = ns.board_x + half_w - sheet_half;
		var drift_speed = ns.drift_speed;
		
		if (ns.drift_pause_timer > 0) {
			ns.drift_pause_timer -= _dt;
			return;
		}
			
		ns.sheet_x += ns.drift_dir * drift_speed * _dt;
			
		if (ns.sheet_x <= min_x) {
			ns.sheet_x = min_x;
			ns.drift_dir = 1;
			ns.drift_pause_timer = random_range(0.2, 0.6);
		    ns.drift_speed = random_range(10, 15);
		}
		if (ns.sheet_x >= max_x) {
			ns.sheet_x = max_x;
			ns.drift_dir = -1;
			ns.drift_pause_timer = random_range(0.2, 0.6);
		    ns.drift_speed = random_range(10, 15);
		}
	}
				
	function update_movement(_dt) {
	
		var ns = noodle_station;
		var profile = move_profile[ns.move_profile_id];
		
		if (profile.mspeed == 0) return;
		if (ns.move_count >= profile.max_moves) return;
		if (ns.state != NOODLE_STATE.ACTIVE) return;
		if (ns.move_lock_timer > 0) {
			ns.move_lock_timer -= _dt;
			return;
		}
		
		switch (ns.move_state) {
			
			case NOODLE_MOVE_STATE.IDLE:
				
				ns.move_cooldown -= _dt;
				
				if (ns.move_cooldown <= 0) {
					if (random(1) < profile.frequecy) {
						ns.move_state = NOODLE_MOVE_STATE.WARNING;
						ns.move_timer = 0.1;
						ns.is_fake = false;
						if (profile.can_fake && ns.fake_count < 1) {
							ns.is_fake = (random(1) < 0.4);
						}
					}
					
					ns.move_cooldown = random_range(profile.cooldown_min, profile.cooldown_max);
					
				}
				
			break;
			
			
			case NOODLE_MOVE_STATE.WARNING:
			
				ns.move_timer -= _dt;
				ns.warning_offset_x = random_range(-1, 1);
				ns.warning_glow = 0.50;
				
				if (ns.move_timer <= 0) {
					if (ns.is_fake) {
			
						ns.fake_count += 1;
						ns.move_state = NOODLE_MOVE_STATE.IDLE;
						ns.warning_offset_x = 0;
						ns.warning_glow = 0;
						
						show_debug_message("FAKE! " + string(ns.fake_count));
						
					} else {
						
						ns.move_state = NOODLE_MOVE_STATE.MOVING;
						ns.move_timer = 0.25;
						ns.warning_offset_x = 0;
						ns.warning_glow = 0;
						
						var dir = choose (-1, 1);
						var dist = profile.distance;
						
						var half_w = ns.board_w * 0.5;
						var sheet_half = sprite_get_width(spr_nd_sheet) * 0.5;
						
						var min_x = ns.board_x - half_w + sheet_half;
						var max_x = ns.board_x + half_w - sheet_half;
						
						var space_left = ns.sheet_x - min_x;
						var space_right = max_x - ns.sheet_x;
						
						var possible_dirs = [];
						
						if (space_left >= dist) array_push(possible_dirs, -1);
						if (space_right >= dist) array_push(possible_dirs, 1);
						
						if (array_length(possible_dirs) == 0) {
							ns.move_state = NOODLE_MOVE_STATE.IDLE;
							ns.move_cooldown = 0.1;
							break;
						}
						
						var dir = possible_dirs[irandom(array_length(possible_dirs)-1)];
						
						ns.move_target_x = ns.sheet_x + dir * dist;
						
					}
				}
				
			break;
		
			
			
			case NOODLE_MOVE_STATE.MOVING:
			
				ns.move_timer -= _dt;
				
				var dx = ns.move_target_x - ns.sheet_x;
				var step = profile.mspeed * _dt;
				
				if (abs(dx) > step) {
					
					ns.sheet_x += sign(dx) * step;
					
				} else {
					
					ns.sheet_x = ns.move_target_x;
				}
				
				if (ns.move_timer <= 0) {
					
					ns.move_state = NOODLE_MOVE_STATE.IDLE;
					ns.move_count += 1;
					
					show_debug_message("Movimiento realizado: " + string(ns.move_count));
				}
				
			break;
			
		}
		
	}

	function reset() {
		
	    noodle_station.has_sheet = false;
	    noodle_station.cuts = [];
	    noodle_station.type = NOODLE_ID.NONE;
	}		
		
}
