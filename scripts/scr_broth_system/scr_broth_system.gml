function BrothSystem() constructor {

	broth_data = [];
	pots = [];
	pot_positions = [];
	
	
	function init() {
		
		broth_data[BROTH_ID.CHICKEN] = {
		name: "Chicken Broth",
		ready_time: 20,
		burn_time: 30
		};
		
	broth_data[BROTH_ID.ROTTEN] = {
		name: "Rotten Broth",
		ready_time: 10,
		burn_time: 12
		
		};
		
	pots = array_create(2);
	
	for (var i = 0; i < array_length(pots); i++) {
		pots[i] = {
			broth_id: BROTH_ID.NONE,
			progress: 0,
			is_on: false,
			state: POT_STATE.EMPTY
			};
		}
		
	pot_positions = [];
	var center_x = 640 * 0.5;
	var center_y = 360 * 0.5;
	var spacing = 100;

	var sw = sprite_get_width(spr_pot) * 1.1;
	var sh = sprite_get_height(spr_pot) * 1.1;

	pot_positions[0] = { 
		x: center_x - spacing, 
		y: center_y, 
		w: sw, 
		h: sh 
	};
	pot_positions[1] = { 
		x: center_x + spacing, 
		y: center_y, 
		w: sw, 
		h: sh 
	};
	}
	
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
		
	function update() {
		
		for (var i = 0; i < array_length(pots); i++) {
			
			var pot = pots[i];
			
			
			if (pot.is_on && pot.broth_id != BROTH_ID.NONE) {
				
				var data = broth_data[pot.broth_id];
				
				pot.progress += delta_time / 1000000;
				
				if (pot.progress >= data.ready_time && pot.progress < data.burn_time) {
					pot.state = POT_STATE.READY
				}
				
				if (pot.progress >= data.burn_time) {
					pot.state = POT_STATE.BURNED;
				}
			}
			
			pots[i] = pot;
		}
	}
		
}