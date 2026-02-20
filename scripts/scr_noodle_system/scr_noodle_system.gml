function NoodleSystem() constructor {
	
	noodle_data = [];
	noodle_station = [];
	
	move_timer = 0;
	move_count = 0;
	max_moves = 2;
	
	function set_board_geometry(_gui_w, _gui_h) {
		
		noodle_station.board_w = sprite_get_width(spr_nd_board);
		noodle_station.board_h = sprite_get_height(spr_nd_board);
		
		noodle_station.board_x = round(_gui_w * 0.07 + noodle_station.board_w * 0.5);
		noodle_station.board_y = round(_gui_h * 0.25 + noodle_station.board_h * 0.5);

	}
	
	function init() {
		
		noodle_data[NOODLE_ID.NONE] = {
			name: "None",
			move_level: 0,
			regen: false
		};
		noodle_data[NOODLE_ID.WHEAT] = {
			name: "Wheat Noodles",
			move_level: 0,
			regen: false
		};
		noodle_data[NOODLE_ID.MUCUS] = {
			name: "Mucus Noodles",
			move_level: 1,
			regen: false
		};
		noodle_data[NOODLE_ID.LEY] = {
			name: "Ley Noodles",
			move_level: 2,
			regen: false
		};
		noodle_data[NOODLE_ID.CURSED] = {
			name: "Cursed Noodles",
			move_level: 3,
			regen: true
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
			board_h: 0
			
		};
	}
		
	function start_sheet(_type, _target_cm) {
		if (_type == NOODLE_ID.NONE) return;
		if (_target_cm <= 0) return;
		
		noodle_station.sheet_x = noodle_station.board_x;
		noodle_station.sheet_y = noodle_station.board_y;
		noodle_station.has_sheet = true;
		noodle_station.type = _type;
		noodle_station.target_cm = _target_cm;
		noodle_station.cuts = [];
		noodle_station.state = NOODLE_STATE.ACTIVE;
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

	function reset() {
		
	    noodle_station.has_sheet = false;
	    noodle_station.cuts = [];
	    noodle_station.type = NOODLE_ID.NONE;
	}		
		
}
