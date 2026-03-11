function NoodleSystem() constructor {
	
	noodle_data = [];
	noodle_station = [];

	function set_board_geometry(_gui_w, _gui_h) {
		
		noodle_station.board_w = sprite_get_width(spr_nd_board);
		noodle_station.board_h = sprite_get_height(spr_nd_board);
		
		noodle_station.board_x = round(_gui_w * 0.07 + noodle_station.board_w * 0.5);
		noodle_station.board_y = round(_gui_h * 0.25 + noodle_station.board_h * 0.5);

	}
	
	function init() {
		
		noodle_data[NOODLE_ID.NONE] = {
			name: "None"
		};
		noodle_data[NOODLE_ID.WHEAT] = {
			name: "Wheat Noodles"
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
			
			ritual_available: false,
			ritual_active: false,
			ritual_complete: false,
			ritual_prev_state: NOODLE_STATE.NO_SHEET,
			ritual_type: NOODLE_ID.NONE,
			ritual_sequence: [],
			ritual_index: 0,
			ritual_show_index: 0,
			ritual_timer: 0,
			ritual_show_on: true,
			
			ritual_input_lock: 0
			

		};
	}
			
	function start_sheet(_target_cm) {
		if (_target_cm <= 0) return;
		
		noodle_station.sheet_x = noodle_station.board_x;
		noodle_station.sheet_y = noodle_station.board_y;
		noodle_station.has_sheet = true;
		noodle_station.type = NOODLE_ID.WHEAT;
		noodle_station.target_cm = _target_cm;
		noodle_station.cuts = [];
		noodle_station.state = NOODLE_STATE.ACTIVE;
		noodle_station.ritual_available = false;
		
		
	}
	
	function add_cut(_cm) {
		if (!noodle_station.has_sheet) return;
		if (noodle_station.state != NOODLE_STATE.ACTIVE && 
			noodle_station.state != NOODLE_STATE.CUTTING) return;	
	
		array_push(noodle_station.cuts, _cm);
		
		if (array_length(noodle_station.cuts) == 1) {
			noodle_station.state = NOODLE_STATE.CUTTING;
			noodle_station.ritual_available = true;
		}
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
		
		var station = noodle_station;
		
		if (station.ritual_input_lock > 0) {
			station.ritual_input_lock--;
		}
		
		switch (station.state) {
			
			case NOODLE_STATE.RITUAL_PATTERN:
				update_ritual_pattern();
			break;
			
			case NOODLE_STATE.RITUAL_FAIL:
				update_ritual_fail();
			break;
			
		}
	}
	
	function update_ritual_pattern() {
		
		var station = noodle_station;

		station.ritual_timer--;
		
		if (station.ritual_timer > 0) return;
		
		if (station.ritual_show_on) {
			
			station.ritual_show_on = false;
			station.ritual_timer = 12;
			
		} else {
			
			station.ritual_show_index++;
		
			if (station.ritual_show_index >= array_length(station.ritual_sequence)) {
			
				station.ritual_index = 0;
				station.state = NOODLE_STATE.RITUAL_INPUT;
				return;
			}
			
			station.ritual_show_on = true;
			station.ritual_timer = 20;
			
		}
	}
	
	function update_ritual_fail() {
		
		var station = noodle_station;
		
		station.ritual_timer--;
		
		if (station.ritual_timer > 0) return;
		
		start_ritual_pattern();
		
	}

	function reset() {
		
	    noodle_station.has_sheet = false;
	    noodle_station.cuts = [];
	    noodle_station.type = NOODLE_ID.NONE;
	}		
	
	function start_ritual() {
		
		if (!noodle_station.has_sheet) return;
		if (!noodle_station.ritual_available) return;
		if (noodle_station.ritual_complete) return;
		
		noodle_station.ritual_active = true;
		
		noodle_station.ritual_prev_state = noodle_station.state;

		noodle_station.state = NOODLE_STATE.RITUAL_SELECT;
		
	}	
	
	function select_ritual(_noodle_type) {
		
		if (!noodle_station.ritual_active) return;
		if (noodle_station.state != NOODLE_STATE.RITUAL_SELECT) return;
		
		noodle_station.ritual_type = _noodle_type;
		
		if (_noodle_type == NOODLE_ID.WHEAT) {
			
			noodle_station.type = NOODLE_ID.WHEAT;
			noodle_station.ritual_complete = true;
			noodle_station.ritual_active = false;
			noodle_station.state = NOODLE_STATE.COMPLETE;
			
			return;
		}
		
		start_ritual_pattern();
	}
	
	function start_ritual_pattern() {
		
		var station = noodle_station;
		
		station.ritual_sequence = [];
		station.ritual_index = 0;
		station.ritual_show_index = 0;
		
		var length = 6;
		
		repeat(length) {
			array_push(station.ritual_sequence, irandom(5));
		}
		
		station.ritual_show_on = true;
		station.ritual_timer = 27;
		station.state = NOODLE_STATE.RITUAL_PATTERN;
		
	}
		
	function get_current_rune() {
		
		var station = noodle_station;
		
		if (station.state != NOODLE_STATE.RITUAL_PATTERN) return -1;
		if (!station.ritual_show_on) return -1;
		if (station.ritual_show_index >= array_length(station.ritual_sequence)) return -1;
		
		return station.ritual_sequence[station.ritual_show_index];
		
	}
		
	function press_rune(_rune_index) {
		
		var station = noodle_station;
		
		if (station.state != NOODLE_STATE.RITUAL_INPUT) return;
		if (station.ritual_input_lock > 0) return;
		
		var expected = station.ritual_sequence[station.ritual_index];
		
		station.ritual_input_lock = 8;
		
		if (_rune_index == expected) {
			
			station.ritual_index++;
			
			if (station.ritual_index >= array_length(station.ritual_sequence)) {
				ritual_success();
			}	
			
		} else {
			
			ritual_fail();
			
		}
	}
	
	function ritual_success() {
		
		var station = noodle_station;
		station.type = station.ritual_type;
		
		station.ritual_complete = true;
		station.ritual_active = false;
		
		station.state = NOODLE_STATE.COMPLETE;
		
	}
	
	function ritual_fail() {
		
		var station = noodle_station;
		
		station.state = NOODLE_STATE.RITUAL_FAIL;
		station.ritual_timer = 45;
		
	}
	
	function close_ritual_ui() {
		
		if (!noodle_station.ritual_active) return;
		
		noodle_station.state = noodle_station.ritual_prev_state;
		
	}
		
		
}
