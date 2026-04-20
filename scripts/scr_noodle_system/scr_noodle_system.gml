function NoodleSystem() constructor {
	
	noodle_data = [];
	noodle_station = [];
	is_passive = false;
	my_station = STATION.NOODLES;
	
	function init() {
		
		noodle_data[NOODLE_ID.NONE]  = { name: "None" };
		noodle_data[NOODLE_ID.WHEAT] = { name: "Wheat Noodles" };
		
		ritual_rune_x = [];
		ritual_rune_y = [];
		ritual_seq_lenght = 5;
		
		noodle_station = {
			
			has_sheet: false,
			type: NOODLE_ID.NONE,
			cuts: [],
			state: NOODLE_STATE.NO_SHEET,
			
			sheet_x: 0,
			sheet_y: 0,
			
			board_x: 0,
			board_y: 0,
			board_w: 0,
			board_h: 0,
			
			ritual_available: false,
			ritual_complete: false,
			ritual_prev_state: NOODLE_STATE.NO_SHEET,
			ritual_type: NOODLE_ID.NONE,
			ritual_sequence: [],
			ritual_index: 0,
			ritual_show_index: 0,
			ritual_timer: 0,
			ritual_show_on: true,
			ritual_last_pressed: -1,
			ritual_last_timer: 0,
			ritual_last_correct: false,
			
			ritual_input_lock: 0
		};
	}

	function set_board_geometry(_gui_w, _gui_h) {
		noodle_station.board_w = sprite_get_width(spr_nd_board);
		noodle_station.board_h = sprite_get_height(spr_nd_board);
		
		noodle_station.board_x = round(_gui_w * 0.07 + noodle_station.board_w * 0.5);
		noodle_station.board_y = round(_gui_h * 0.25 + noodle_station.board_h * 0.5);
	}			

	function start_sheet() {
		
		var s = noodle_station;
		
		s.sheet_x = s.board_x;
		s.sheet_y = s.board_y;
		s.has_sheet = true;
		s.type = NOODLE_ID.WHEAT;
		s.cuts = [];
		s.state = NOODLE_STATE.ACTIVE;
		s.ritual_available = false;
	}
	
	function add_cut(_cm) {
		var s = noodle_station;
		
		if (!s.has_sheet) return;
		if (s.state != NOODLE_STATE.ACTIVE && s.state != NOODLE_STATE.CUTTING) return;	
	
		array_push(s.cuts, _cm);
		array_sort(s.cuts, true);
		
		if (array_length(s.cuts) == 1) {
			s.state = NOODLE_STATE.CUTTING;
			s.ritual_available = true;
		}
	}
		
	function can_serve() {
		return noodle_station.has_sheet && array_length(noodle_station.cuts) >= 1;
	}
	
	function get_result() {
	    return { 
			noodle_id: noodle_station.type,
	        cuts: noodle_station.cuts
	    };
	}

	function should_update(_current_station) {
		return is_passive || _current_station == my_station;	
	}

	function update(_dt) {
		var s = noodle_station;
		
		if (s.ritual_input_lock > 0) s.ritual_input_lock--;
		if (s.ritual_last_timer > 0) s.ritual_last_timer--;
		
		switch (s.state) {
			case NOODLE_STATE.RITUAL_TRANSFORM: update_ritual_transform(); break;
			case NOODLE_STATE.RITUAL_PATTERN:   update_ritual_pattern();   break;
			case NOODLE_STATE.RITUAL_FAIL:      update_ritual_fail();      break;
		}
		
		if (s.state >= NOODLE_STATE.RITUAL_TRANSFORM) {
			update_rune_positions();
		}
	}

	function update_ritual_transform() {
		var s = noodle_station;
		
		s.ritual_timer--;
		if (s.ritual_timer > 0) return;
		
		start_ritual_pattern();
	}
	
	function update_ritual_pattern() {
		var s = noodle_station;

		s.ritual_timer--;
		if (s.ritual_timer > 0) return;
		
		if (s.ritual_show_on) {
			s.ritual_show_on = false;
			s.ritual_timer = 30;
		} else {
			s.ritual_show_index++;
		
			if (s.ritual_show_index >= array_length(s.ritual_sequence)) {
				s.ritual_index = 0;
				s.state = NOODLE_STATE.RITUAL_INPUT;
				return;
			}
			
			s.ritual_show_on = true;
			s.ritual_timer = 45;
		}
	}
	
	function update_ritual_fail() {
		var s = noodle_station;
		
		s.ritual_timer--;
		if (s.ritual_timer > 0) return;
		
		start_ritual_pattern();
	}
	
	function update_rune_positions() {
		var s = noodle_station;

		var cx = s.sheet_x;
		var cy = s.sheet_y;

		var radius = (sprite_get_width(spr_nd_ritual_circle) * 0.5)
				   - (sprite_get_width(spr_nd_ritual_runes) * 0.5);

		var step = 360 / 6;
		
		for (var i = 0; i < 6; i++) {
			var ang = -90 + i * step;
			ritual_rune_x[i] = cx + lengthdir_x(radius, ang);
			ritual_rune_y[i] = cy + lengthdir_y(radius, ang);
		}
	}

	function reset() {
		var s = noodle_station;
		
		s.has_sheet = false;
		s.cuts = [];
		s.type = NOODLE_ID.NONE;
		s.ritual_complete = false;
		s.ritual_available = false;
		s.state = NOODLE_STATE.NO_SHEET;
	}		
	
	function start_ritual() {
		var s = noodle_station;
		
		if (!s.has_sheet) return;
		if (!s.ritual_available) return;
		if (s.ritual_complete) return;
		
		s.ritual_prev_state = s.state;
		s.state = NOODLE_STATE.RITUAL_SELECT;
	}	
	
	function select_ritual(_noodle_type) {
		var s = noodle_station;
		
		if (s.state != NOODLE_STATE.RITUAL_SELECT) return;
		
		if (s.ritual_type != _noodle_type) {
			s.ritual_sequence = [];
			s.ritual_index = 0;
			s.ritual_show_index = 0;			
		}

		s.ritual_type = _noodle_type;
		s.state = NOODLE_STATE.RITUAL_TRANSFORM;
		s.ritual_timer = 120;
		
		if (_noodle_type == NOODLE_ID.WHEAT) {
			s.type = NOODLE_ID.WHEAT;
			s.state = NOODLE_STATE.CUTTING;
		}
	}
	
	function start_ritual_pattern() {
		var s = noodle_station;
		
		s.ritual_sequence = [];
		s.ritual_index = 0;
		s.ritual_show_index = 0;
		
		repeat(ritual_seq_lenght) {
			array_push(s.ritual_sequence, irandom(5));
		}
		
		s.ritual_show_on = true;
		s.ritual_timer = 27;
		s.state = NOODLE_STATE.RITUAL_PATTERN;
	}
		
	function get_current_rune() {
		var s = noodle_station;
		
		if (s.state != NOODLE_STATE.RITUAL_PATTERN) return -1;
		if (!s.ritual_show_on) return -1;
		if (s.ritual_show_index >= array_length(s.ritual_sequence)) return -1;
		
		return s.ritual_sequence[s.ritual_show_index];
	}
		
	function press_rune(_rune_index) {
		
		var s = noodle_station;
		
		if (array_length(s.ritual_sequence) == 0) return;
		if (s.state != NOODLE_STATE.RITUAL_INPUT) return;
		if (s.ritual_input_lock > 0) return;
		
		s.ritual_last_pressed = _rune_index;
		s.ritual_last_timer = 10;
		
		var expected = s.ritual_sequence[s.ritual_index];
		s.ritual_input_lock = 1;
		
		if (_rune_index == expected) {
			
			s.ritual_last_correct = true;
			s.ritual_index++;
			
			if (s.ritual_index >= array_length(s.ritual_sequence)) {
				ritual_success();
			}
		} else {
			s.ritual_last_correct = false;
			ritual_fail();
		}
	}
	
	function ritual_success() {
		var s = noodle_station;
		
		s.type = s.ritual_type;
		s.ritual_complete = true;
		s.state = NOODLE_STATE.COMPLETE;
	}
	
	function ritual_fail() {
		var s = noodle_station;
		
		s.state = NOODLE_STATE.RITUAL_FAIL;
		s.ritual_timer = 45;
	}
	
	function close_ritual_ui() {
		var s = noodle_station;
		
		if (s.state < NOODLE_STATE.RITUAL_SELECT ||
		    s.state > NOODLE_STATE.RITUAL_FAIL) return;
		
		s.state = s.ritual_prev_state;

		s.ritual_complete = false;
	}
		
}