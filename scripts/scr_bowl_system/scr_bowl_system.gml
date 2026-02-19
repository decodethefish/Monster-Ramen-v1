function BowlSystem(_count) constructor {

	bowls = array_create(_count);

	for (var i = 0; i < _count; i++) {
		bowls[i] = {
			has_broth: false,
			broth_id: BROTH_ID.NONE,
			broth_state: POT_STATE.EMPTY,

			has_noodles: false,
			noodle_id: NOODLE_ID.NONE,
			noodle_quality: 0
		};
	}
	
	function can_receive_broth(_index) {
		return !bowls[_index].has_broth;
	}
	
	function can_receive_noodles(_index) {
		return !bowls[_index].has_noodles;
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
		if (bowl.has_broth) return;

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
	}
	
	function draw(_index, _x, _y) {
		
		var data = bowls[_index];
		
		draw_sprite(spr_bowl_base, 0, _x, _y);
		
		draw_layers(data, _x, _y);
	}
		
	
		
		
}
