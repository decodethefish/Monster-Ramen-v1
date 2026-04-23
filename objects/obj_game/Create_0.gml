display_set_gui_size(640, 360);
gpu_set_texfilter(false);
camera_set_view_pos(view_camera[0], 0, 0);
randomize();
game_mode = GAME_MODE.WORLD;
current_station = undefined;
current_cooking_ui = noone;
current_modal_ui = noone;

// --------- TIEMPO --------- 
time_scale_global = 1;

// --------- FUNCIONES ---------
function request_open_station(_station_id) { 
	
	if (game_mode != GAME_MODE.WORLD) return;

	current_station = _station_id;
	game_mode = GAME_MODE.COOKING;

	if (!instance_exists(obj_tickets_ui)) {
		instance_create_layer(0,0,"UI",obj_tickets_ui);
	}
}


function close_station() {

    if (instance_exists(current_cooking_ui)) {
        instance_destroy(current_cooking_ui);
        current_cooking_ui = noone;
    }
	
	current_ticket = noone;
	
	if (instance_exists(current_customer)) {
		
		if (current_customer.state == CUSTOMER_STATE.INTERACT) {
			current_customer.state = CUSTOMER_STATE.WAIT;
			current_customer.locked = false;
		}
	}
	
	with (obj_tickets_ui) instance_destroy();
	
	current_customer = noone;
    current_station = undefined;
    game_mode = GAME_MODE.WORLD;
}

function get_cooking_state() {
	
	var state = 0;
	var broth = obj_game.broth.pots;
	
	for (var i = 0; i < array_length(broth); i++) {
	
		var p = broth[i];
		
		if (p.broth_id = BROTH_ID.NONE) continue;
		
		var data = obj_game.broth.broth_data[p.broth_id];
		
		if (p.state == POT_STATE.BURNED) return 4;
		if (p.state == POT_STATE.READY) state = max(state, 3);
		
		var t = p.progress / data.ready_time;
		
		if (t >= 0.5) state = max(state, 2);
		else state = max(state, 1);
	}
	
	var grill = obj_game.meat.meat_station.grill_slots;
	
	for (var i = 0; i < array_length(grill); i++) {
	
		var mt = grill[i];
		if (mt == noone) continue;
		
		var data = obj_game.meat.meats_data[mt.type];
		
		if (mt.is_burned) return 4;
		if (mt.in_window) state = max(state, 3);
		
		var t = mt.cook_time / data.cook_ready_time;
		
		if (t >= 0.5) state = max(state, 2);
		else state = max(state, 1);
	}
	
	return state;
}
	
function open_modal_ui(_ui_obj) {
	
	if (instance_exists(current_modal_ui)) return;
	current_modal_ui = instance_create_layer(0, 0, "UI", _ui_obj);
	
}

function close_modal_ui() {
	
	if (instance_exists(current_modal_ui)) {
		instance_destroy(current_modal_ui);
		current_modal_ui = noone;
	}
}


// --------- ESTACIONES y BOWLS ---------
bowls = new BowlSystem(3);

broth = new BrothSystem();
broth.init();

noodles = new NoodleSystem();
noodles.init();

eggs = new EggSystem();
eggs.init();

meat = new MeatSystem();
meat.init();

veggies = new VeggiesSystem(); 
veggies.init();

// ------------ SISTEMAS DE JUEGO -------------
customers = new CustomerSystem();
order_system = new QualitySystem();

tickets = new TicketSystem();
current_ticket = noone;

customers.init();
current_customer = noone;

global.order_dialog_db = scr_ord_dialog_db();