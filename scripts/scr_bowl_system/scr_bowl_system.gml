function BowlSystem(_count) constructor {

	bowls = array_create(_count);
	bowl_drag_lock_by_station = [];

	for (var i = 0; i < _count; i++) {
		bowls[i] = {
			
			has_broth: false,
			broth_id: BROTH_ID.NONE,
			broth_state: POT_STATE.EMPTY,

			has_noodles: false,
			noodle_id: NOODLE_ID.NONE,
			noodle_quality: 0,
			
			has_egg: false,
			egg_type: -1,
			
			has_meat: false,
			meat_type: -1,
			meat_quality: 0,
			
			has_veggie: false,
			veg_type: -1,
			veg_result: -1,
			
		};
	}
	
	function add_broth(_bowl_index, _pot_index, _pots) {

		if (_bowl_index < 0) return;
		if (_bowl_index >= array_length(bowls)) return;

		if (_pot_index < 0) return;
		if (_pot_index >= array_length(_pots)) return;

		var pot = _pots[_pot_index];

		if (pot.broth_id == BROTH_ID.NONE) return;
		if (pot.state != POT_STATE.READY && pot.state != POT_STATE.BURNED) return;

		var bowl = bowls[_bowl_index];

		bowl.has_broth = true;
		bowl.broth_id = pot.broth_id;
		bowl.broth_state = pot.state;

		bowls[_bowl_index] = bowl;

		// limpiar olla
		pot.broth_id = BROTH_ID.NONE;
		pot.progress = 0;
		pot.is_on = false;
		pot.state = POT_STATE.EMPTY;

		_pots[_pot_index] = pot;
	}
	
	function add_noodles(_bowl_index, _result) {
		
		if (_bowl_index < 0) return;
		if (_bowl_index >= array_length(bowls)) return;
		
		var bowl = bowls[_bowl_index]
		
		
		bowl.has_noodles = true;
		bowl.noodle_id = _result.noodle_id;
		bowl.noodle_quality = _result.quality;
		
		bowls[_bowl_index] = bowl;

	}
	
	function add_egg(_bowl_index, _egg_type) {
		
		if (_bowl_index < 0) return;
		if (_bowl_index >= array_length(bowls)) return;
		
		var bowl = bowls[_bowl_index];
		
		bowl.has_egg = true;
		bowl.egg_type = _egg_type;
		
		bowls[_bowl_index] = bowl;
		
	}
	
	function add_meat(_bowl_index, _meat) {
	
		if (_bowl_index < 0) return;
		if (_bowl_index >= array_length(bowls)) return;
		
		var bowl = bowls[_bowl_index];
		
		bowl.has_meat = true;
		bowl.meat_type = _meat.type;
		bowl.meat_quality = _meat.quality;
		
		bowls[_bowl_index] = bowl;
	}
		
	function add_veggie(_bowl_index, _item) {
	
		if (_bowl_index < 0) return;
		if (_bowl_index >= array_length(bowls)) return;
		
		var bowl = bowls[_bowl_index];
		
		bowl.has_veggie = true;
		bowl.veg_type = _item.veg_type;
		
		if (_item.kind == ITEM_KIND.RESULT) {
			bowl.veg_result = _item.result_type;
		} else {
			bowl.veg_result = -1;
		}
		
		bowls[_bowl_index] = bowl;
	
	}
	
	function draw_layers(_data, _x, _y) {
		
		// broth
		if (_data.has_broth) {
			
			var frame = _data.broth_id -1;
			
			draw_sprite(
				spr_bowl_broth,
				frame,
				_x,
				_y
				);
				
			if (_data.broth_state == POT_STATE.BURNED) {
				draw_sprite(
				spr_bowl_brothburnoverlay,
				0,
				_x,
				_y
				);
				
			}
		}
		
		// noodles
		if (_data.has_noodles) {
			
			draw_sprite(
				spr_bowl_noodles,
				_data.noodle_id,
				_x,
				_y
				);	
		}		
		
		// eggs
		if (_data.has_egg) {
			
			draw_sprite(
				spr_bowl_egg,
				_data.egg_type,
				_x,
				_y
				);
		}
		
		// meat
		if (_data.has_meat) {
			draw_sprite(
				spr_bowl_meat,
				_data.meat_type -1,
				_x,
				_y
			);
		}

		// veggies
		if (_data.has_veggie) {
	
			var spr = obj_game.veggies.get_bowl_sprite(_data.veg_type);
	
			var frame = (_data.veg_result != -1)
				? _data.veg_result + 1
				: 0;
	
			draw_sprite(spr, frame, _x, _y);
		}
		
	}
	
	function draw(_index, _x, _y) {
		
		var data = bowls[_index];
		
		draw_sprite(spr_bowl_base, 0, _x, _y);
		
		draw_layers(data, _x, _y);
	}
		
	function set_drag_locked_for_station(_station_id, _locked) {
		if (_station_id < 0) return;
		bowl_drag_lock_by_station[_station_id] = _locked;
	}

	function is_drag_locked_for_station(_station_id) {

		if (_station_id < 0) return false;
		if (_station_id >= array_length(bowl_drag_lock_by_station)) return false;

		var val = bowl_drag_lock_by_station[_station_id];

		if (is_undefined(val)) return false;

		return val;
	}
		
}
