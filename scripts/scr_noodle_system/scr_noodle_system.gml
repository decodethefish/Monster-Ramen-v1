function NoodleSystem() constructor {
	
	noodle_data = [];
	noodle_station = [];
	
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
			state: NOODLE_STATE.NO_SHEET
		};
	}
		
	function start_sheet(_type, _target_cm) {
		if (_type == NOODLE_ID.NONE) return;
		if (_target_cm <= 0) return;
	
		noodle_station.has_sheet = true;
		noodle_station.type = _type;
		noodle_station.target_cm = _target_cm;
		noodle_station.cuts = [];
		noodle_station.state = NOODLE_STATE.READY;
	}
	
	function add_cut(_cm) {
		if (!noodle_station.has_sheet) return;
		if (noodle_station.state != NOODLE_STATE.READY &&
			noodle_station.state != NOODLE_STATE.CUTTING) return;
	
		array_push(noodle_station.cuts, _cm);
	
		if (noodle_station.state == NOODLE_STATE.READY) {
			noodle_station.state = NOODLE_STATE.CUTTING;
		}
	}
	
	function finish_sheet() {
	
		if (!noodle_station.has_sheet) return;
	
		// ordenar cortes
		array_sort(noodle_station.cuts, true);
	
		var target = noodle_station.target_cm;
		var sheet_length = 10;
	
		// -- validar if cantidad correcta de cortes ---
		var expected_segments = sheet_length / noodle_station.target_cm;
		var expected_cuts = expected_segments - 1;
	
		// debug
		show_debug_message("Target actual: " + string(noodle_station.target_cm));
		show_debug_message("Cortes hechos: " + string(array_length(noodle_station.cuts)));
		show_debug_message("Cortes esperados: " + string(expected_cuts));
	
	
		if (array_length(noodle_station.cuts) != expected_cuts) {
			show_debug_message("Incorrect number of cuts. Try again, kid!");
			return;
		}
	
		// ------ calcular calidad -------
	
		var prev = 0;
		var total_error = 0;
	
		for (var i = 0; i < array_length(noodle_station.cuts); i++) {
		
			var current = noodle_station.cuts[i];
			var segment = current - prev;
		
			total_error += abs(segment - target);
		
			prev = current;
		}
	
	
		// ultimo segmento
		var last_segment = 10 - prev;
		total_error += abs(last_segment - target);
	
		// normalizar error - calidad
		var segments = expected_segments;
		var max_error_per_segment = 1;
		var max_error = segments * max_error_per_segment;
	
		var quality = 1 - (total_error / max_error);
		quality = clamp(quality,0,1);
	
	
		// guardar resultado
		noodle_station.quality = quality;
		noodle_station.state = NOODLE_STATE.DONE;
	
		show_debug_message("Noodle sheet complete! - Overall quality: " + string(quality));
		
	}
}