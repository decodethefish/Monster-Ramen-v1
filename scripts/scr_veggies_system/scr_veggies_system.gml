function VeggiesSystem() constructor {

	is_passive = false;
	my_station = STATION.VEGGIES;

	function init() {
		
		veggies_data = [];
		veggies_data[VEGGIE_TYPE.CARROT]   = {};
		veggies_data[VEGGIE_TYPE.MUSHROOM] = {};
		veggies_data[VEGGIE_TYPE.BOK_CHOY] = {};
	
		gems_data = [];
		gems_data[GEM_TYPE.CRIMSON] = {};
		gems_data[GEM_TYPE.SOUL]    = {};
		gems_data[GEM_TYPE.ARCANE]  = {};
		
		veggie_station = {
			
			spd: 60,
			veg_timer: 0,
			gem_timer: 0,			
			
			veg_lane: [],
			gem_lane: [],
			veg_lane_y: 0,
			gem_lane_y: 0,
			lane_x: 0,
			lane_w: 0,
			lane_h: 0,
			lane_spacing: 48,
			item_spawn_x: 0,
			item_spawn_y: 0,
			item_spawn_y_offset: -6,
			max_board_items: 6,
			
			drag_item: noone,
			
			board_items: [],
			board_base: noone,
			board_max_mods: 5,
			board_x: 0,
			board_y: 0,
			board_w: 0,
			board_h: 0,
			
			trash_x : 0,
			trash_y : 0,
			trash_w : sprite_get_width(spr_vg_trash),
			trash_h : sprite_get_height(spr_vg_trash),
			
			guide_frame : 0,
			guide_x : 0,
			guide_y : 0,
			guide_w : sprite_get_width(spr_vg_guide),
			guide_h : sprite_get_height(spr_vg_guide),
			
			open_guide : false,
			
			result: noone
		};
	
		recipe_t1 = ds_map_create();
		recipe_t2 = ds_map_create();

		// T1
		recipe_t1[? "0_0"] = VEGGIE_RESULT.BLEEDING;
		recipe_t1[? "0_1"] = VEGGIE_RESULT.SPECTRAL;
		recipe_t1[? "0_2"] = VEGGIE_RESULT.MAGICAL;

		// T2
		recipe_t2[? "0_1"] = VEGGIE_RESULT.CORRUPT;
		recipe_t2[? "0_2"] = VEGGIE_RESULT.CURSED;
		recipe_t2[? "1_2"] = VEGGIE_RESULT.DARK;
	
		veggie_result_data = [];
		
		// Tier 1
		veggie_result_data[VEGGIE_RESULT.BLEEDING] = {tier: VEGGIE_TIER.T1};
		veggie_result_data[VEGGIE_RESULT.SPECTRAL] = {tier: VEGGIE_TIER.T1};
		veggie_result_data[VEGGIE_RESULT.MAGICAL] = {tier: VEGGIE_TIER.T1};
		
		// Tier 2
		veggie_result_data[VEGGIE_RESULT.CORRUPT] = {tier: VEGGIE_TIER.T2};
		veggie_result_data[VEGGIE_RESULT.CURSED] = {tier: VEGGIE_TIER.T2};
		veggie_result_data[VEGGIE_RESULT.DARK] = {tier: VEGGIE_TIER.T2};
		
		// Tier 3
		veggie_result_data[VEGGIE_RESULT.ALCHEMICAL] = {tier: VEGGIE_TIER.T3};
		
		// Tier 4
		veggie_result_data[VEGGIE_RESULT.PARADOX] = {tier: VEGGIE_TIER.T4};
		
		// Tier 5
		veggie_result_data[VEGGIE_RESULT.ETERNAL] = {tier: VEGGIE_TIER.T5};
			
		
	}

	function update(_dt) {
		
		var s = veggie_station;
		s.veg_timer -= _dt;
		s.gem_timer -= _dt;


		if (s.veg_timer <= 0) {
		
			var item = item_create_veg(
				irandom_range(0, 2),
				s.item_spawn_x
			);
			
			array_push(s.veg_lane, item);
			s.veg_timer = 1.5;
		
		}
		
		if (s.gem_timer <= 0) {
		
			var item = item_create_gem(
				irandom_range(0, 2),
				s.item_spawn_x
			);
			
			array_push(s.gem_lane, item);
			s.gem_timer = 2.5;
		
		}
		
		var spd = s.spd * _dt;
		
		for (var i = 0; i < array_length(s.veg_lane); i++) {
			var it = s.veg_lane[i];
			
			if (it.state == "lane") {
				it.x += spd;
			}

		}
		
		for (var i = 0; i < array_length(s.gem_lane); i++) {
			var it = s.gem_lane[i];
			
			if (it.state == "lane") {
				it.x += spd;
			}

		}
		
		var gui_w = display_get_gui_width();
		var margin = 32;
		
		for (var i = array_length(s.veg_lane) - 1; i >= 0; i--) {
			var it = s.veg_lane[i];
			
			if (it.x > gui_w + margin) {
				array_delete(s.veg_lane, i, 1);
			}
		}
		
		for (var i = array_length(s.gem_lane) - 1; i >= 0; i--) {
			var it = s.gem_lane[i];
			
			if (it.x > gui_w + margin) {
				array_delete(s.gem_lane, i, 1);
			}
		}		
	}

	function should_update(_current_station) {
		return is_passive || _current_station == my_station;	
	}

	function set_board_geometry(_gui_w, _gui_h) {
		
		var s = veggie_station;
		var w = sprite_get_width(spr_vg_board);
		var h = sprite_get_height(spr_vg_board);
		
		s.board_w = w;
		s.board_h = h;
		
		s.board_x = _gui_w * 0.5;
		s.board_y = _gui_h - h * 0.5;
		
	}	

	function set_conveyor_geometry(_gui_w, _gui_h) {

		var s = veggie_station;

		s.lane_w = sprite_get_width(spr_vg_conveyor);
		s.lane_h = sprite_get_height(spr_vg_conveyor);

		s.lane_x = s.board_x;

		s.item_spawn_x = s.lane_x - s.lane_w * 0.5 - 32;

		var board_top = s.board_y - s.board_h * 0.5;
		
		var gem_offset = 38;
		s.gem_lane_y = board_top - gem_offset;
		
		s.veg_lane_y = s.gem_lane_y - s.lane_spacing;
	}
	
	function set_trash_geometry(_gui_w, _gui_h) {
		
		var s = veggie_station;
		var half = veggie_station.trash_w * 0.5;
		var margin = 24;
		
		s.trash_x = 0 + half + margin;
		s.trash_y = _gui_h - half - margin;
	
	}
		
	function set_guide_geometry(_gui_w, _gui_h) {
		
		var s = veggie_station;
		var half = veggie_station.guide_w * 0.5;
		var margin_x = 24;
		var margin_y =  veggie_station.guide_w * 2;
		
		s.guide_x = 0 + half + margin_x;
		s.guide_y = _gui_h - half - margin_y;
	
	}
	
	function item_create_veg(_veg_type, _x) {
		return {
			kind: ITEM_KIND.VEG,
			veg_type: _veg_type,
			gem_type: -1,
			result_type: -1,
			tier: 0,
			x: _x,
			y: 0,
			state: "lane",
		};
	}
		
	function item_create_gem(_gem_type, _x) {
		return {
			kind: ITEM_KIND.GEM,
			veg_type: -1,
			gem_type: _gem_type,
			result_type: -1,
			tier: 0,
			x: _x,
			y: 0,
			state: "lane"
		};
	}
	
	function board_item_create(_it, _x, _y) {
		
		return {
			kind: _it.kind,
			veg_type: _it.veg_type,
			gem_type: _it.gem_type,
			result_type: _it.result_type,
			tier: _it.tier,
			x: _x,
			y: _y,
			state: "board"
		};	
	}

	function make_key(_a, _b) {
		return string(min(_a, _b)) + "_" + string(max(_a, _b));
	}
	
	function combine_items(a, b) {

		// T1
		if (a.kind == ITEM_KIND.VEG && b.kind == ITEM_KIND.GEM) {
			return make_t1(a.veg_type, b.gem_type);
		}
	
		if (a.kind == ITEM_KIND.GEM && b.kind == ITEM_KIND.VEG) {
			return make_t1(b.veg_type, a.gem_type);
		}

		// RESULT + RESULT
		if (a.kind == ITEM_KIND.RESULT && b.kind == ITEM_KIND.RESULT) {
			
			if (a.veg_type != b.veg_type) {
				return noone;		
			}
				
			// T2
			var key = make_key(a.result_type, b.result_type);
		
			if (ds_map_exists(recipe_t2, key)) {
				return make_result(a.veg_type, recipe_t2[? key], 2);
			}
		
			// T3
			if (a.tier == 2 && b.tier == 2) {
				return make_result(a.veg_type, VEGGIE_RESULT.ALCHEMICAL, 3);
			}
		
			// T4
			if (a.result_type == VEGGIE_RESULT.ALCHEMICAL &&
				b.result_type == VEGGIE_RESULT.ALCHEMICAL) {
				return make_result(a.veg_type, VEGGIE_RESULT.PARADOX, 4);
			}
		
			// T5
			if (a.result_type == VEGGIE_RESULT.PARADOX &&
				b.result_type == VEGGIE_RESULT.PARADOX) {
				return make_result(a.veg_type, VEGGIE_RESULT.ETERNAL, 5);
			}
		}

		return noone;
	}

	function make_t1(_veg_type, _gem_type) {

		var result;

		switch (_gem_type) {
			case GEM_TYPE.CRIMSON: result = VEGGIE_RESULT.BLEEDING; break;
			case GEM_TYPE.SOUL:    result = VEGGIE_RESULT.SPECTRAL; break;
			case GEM_TYPE.ARCANE:  result = VEGGIE_RESULT.MAGICAL; break;
		}

		return make_result(_veg_type, result, 1);
	}

	function make_result(_veg_type, _result_type, _tier) {
		return {
			kind: ITEM_KIND.RESULT,
			veg_type: _veg_type,
			gem_type: -1,
			result_type: _result_type,
			tier: _tier
		};
	}

	function get_bowl_sprite(_veg_type) {
	
		switch (_veg_type) {
		
			case VEGGIE_TYPE.CARROT: return spr_bowl_veggie_c;
			case VEGGIE_TYPE.MUSHROOM: return spr_bowl_veggie_m;
			case VEGGIE_TYPE.BOK_CHOY: return spr_bowl_veggie_b;
		
		}
		
		return -1;
		
	}
	
	function cleanup() {

		ds_map_destroy(recipe_t1);
		ds_map_destroy(recipe_t2);
	}
}
