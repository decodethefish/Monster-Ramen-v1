display_set_gui_size(640, 360);

// ENUMS
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
	ACTIVE
}
enum NOODLE_MOVE_STATE {
	IDLE,
	WARNING,
	MOVING
}

game_mode = GAME_MODE.WORLD;

// Tiempo
time_scale_global = 1;

// Estaciones de cocina
current_station = undefined;
current_ui = noone;


// variables provicionales de ordenes
current_order = {
	noodle_target_cm: 2
};

// Funciones
function request_open_station(_station_id) {
	
	if (game_mode != GAME_MODE.WORLD) return;

	current_station = _station_id;
	game_mode = GAME_MODE.COOKING;
}

function close_station() {

    if (instance_exists(current_ui)) {
        instance_destroy(current_ui);
        current_ui = noone;
    }

    current_station = undefined;
    game_mode = GAME_MODE.WORLD;
}

// --------- ESTACIONES y BOWLS ---------

bowls = new BowlSystem(3);

broth = new BrothSystem();
broth.init();

noodles = new NoodleSystem();
noodles.init();
