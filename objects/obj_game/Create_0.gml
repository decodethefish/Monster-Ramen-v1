display_set_gui_size(640, 360);

enum GAME_MODE {
	WORLD,
	COOKING
}
enum STATION {
	BROTH,
	NOODLES,
	MEAT_CUT,
	MEAT_COOK,
	EGGS,
	VEGGIES,
}


enum BROTH_ID {
	NONE,
	CHICKEN,
	ROTTEN
}
enum POT_STATE {
	EMPTY,
	COOKING,
	READY,
	BURNED
}

enum NOODLE_ID {
	NONE,
	WHEAT,
	MUCUS,
	LEY,
	CURSED
}
enum NOODLE_STATE {
	NO_SHEET,
	READY,
	CUTTING,
	DONE
}

game_mode = GAME_MODE.WORLD;

// Tiempo
time_scale_global = 1;

// Estaciones de cocina
current_station = noone;
current_ui = noone;



// variables provicionales de ordenes
current_order = {
	noodle_target_cm: 2
};

// Funciones
function request_open_station(_station_type, _station_id) {
	
	if (game_mode != GAME_MODE.WORLD) {
		return;
	}
	
	current_station = _station_id;
	game_mode = GAME_MODE.COOKING;
	show_debug_message("game mode is now set to COOKING");
}
function close_current_ui() {
	// ...nada aún
}


// ---------- BOWLS --------


// --------- ESTACIÓN DE SOPA ------------

broth_data = [];

broth_data[BROTH_ID.CHICKEN] = {
	name: "Chicken Broth",
	ready_time: 30,
	burn_time: 40
}
broth_data[BROTH_ID.ROTTEN] = {
	name: "Rotten Broth",
	ready_time: 20,
	burn_time: 25
}

pots = array_create(2);
for (var i = 0; i < array_length(pots); i++) {
	pots[i] = {
		broth_id: BROTH_ID.NONE,
		progress: 0,
		is_on: false,
		state: POT_STATE.EMPTY
	};
}

// posiciones de ollas
pot_positions = [];
var center_x = 640 * 0.5;
var center_y = 360 * 0.5;
var spacing = 100;

pot_positions[0] = { 
	x: center_x - spacing, 
	y: center_y, 
	w: 64, 
	h: 64 
};
pot_positions[1] = { 
	x: center_x + spacing, 
	y: center_y, 
	w: 64, 
	h: 64 
};

function get_pot_at_position(_x, _y) {
	
	for (var i = 0; i < array_length(pot_positions); i++) {
		
		var p = pot_positions[i];
		
		var left   = p.x - p.w * 0.5;
		var right  = p.x + p.w * 0.5;
		var top    = p.y - p.h * 0.5;
		var bottom = p.y + p.h * 0.5;
		
		if (_x >= left && _x <= right &&
			_y >= top && _y <= bottom) {
			
			return i;
		}
	}
	
	return -1;
}
	
	
// --------- BOWLS ---------

bowls = new BowlSystem(3);


// ---------- ESTACIÓN DE NOODLES ------------

noodle_data = [];

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

function noodle_start_sheet(_type, _target_cm) {
	if (_type == NOODLE_ID.NONE) return;
	if (_target_cm <= 0) return;
	
	noodle_station.has_sheet = true;
	noodle_station.type = _type;
	noodle_station.target_cm = _target_cm;
	noodle_station.cuts = [];
	noodle_station.state = NOODLE_STATE.READY;
	
	show_debug_message("Noodle sheet started.")
}
function noodle_add_cut(_cm) {
	if (!noodle_station.has_sheet) return;
	if (noodle_station.state != NOODLE_STATE.READY &&
		noodle_station.state != NOODLE_STATE.CUTTING) return;
	
	array_push(noodle_station.cuts, _cm);
	
	if (noodle_station.state == NOODLE_STATE.READY) {
		noodle_station.state = NOODLE_STATE.CUTTING;
	}
	
	show_debug_message("Cut added: " + string(_cm));
}
function noodle_finish_sheet() {
	
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