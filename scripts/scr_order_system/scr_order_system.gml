function OrderSystem() constructor {
	
	function evaluate_bowl(_bowl, _order) {
		
		if (_order == noone) return 0;
		
		var current_score = 0;
		var max_score = 5;
		
		// Broth
		if (_bowl.has_broth) {
    
		    if (_bowl.broth_id == _order.broth) {

		        if (_bowl.broth_state != POT_STATE.BURNED) {
		            current_score += 1;
		        }
		    }
		}		
			
		// Noodles
		if (_bowl.has_noodles && !is_undefined(_bowl.noodle_data)) {
			current_score += evaluate_noodles(_bowl.noodle_data, _order.noodles);
		}
		
		// Meat
		if (_bowl.has_meat && !is_undefined(_bowl.meat_data)) {
			current_score += evaluate_meat(_bowl.meat_data, _order.meat);
		}
		
		// Eggs
		if (_bowl.has_egg && _bowl.egg_type == _order.egg) {
			current_score += 1;	
		}
		
		// Veggies
		if (_bowl.has_veggies && _bowl.veg_type ==  _order.veggies.type) {
			current_score += 1;
		}
		
		return current_score / max_score;
	
	}
	
	function evaluate_meat(_meat_data, _order_meat) {
		
		if (_meat_data == noone) return 0;
		if (_order_meat == noone) return 0;
		
		// tipo incorrecto = fail directo :p
		if (_meat_data.type != _order_meat.type) return 0;
		
		var target = _order_meat.target_tender;
		var times = _meat_data.time_per_zone;
		
		//		TENDER
		var time_in_target = times[target];
		var total = 0;
		
		for (var i = 0; i < array_length(times); i++) {
			total += times[i]	;
		}
		
		if (total <= 0) return 0;
		
		var ratio = time_in_target / total;
		
		var tender_score;
		if (ratio >= 0.7) tender_score = 1;						// perfecto
		else if (ratio >= 0.4) tender_score = 0.6;		// maso
		else tender_score = 0.2;						// pesimo
		
		//		 COOK
		
		var data = obj_game.meat.meats_data[_meat_data.type];
		
		var t = _meat_data.cook_time;
		var ready = data.cook_ready_time;
		var end_t  = data.cook_time;
		
		var cook_score;
		
		if (t < ready) cook_score = 0.3;
		else if (t <= end_t) cook_score = 1;
		else cook_score = 0;
		
		return (tender_score + cook_score) * 0.5;
		
	}
	
	function evaluate_noodles(_noodle_data, _order_noodles) {
	
		if (_noodle_data == noone) return 0;
		if (_order_noodles == noone) return 0;
		
		if (_noodle_data.noodle_id != _order_noodles.type) return 0;
		
		var cuts = _noodle_data.cuts;
		var target = _order_noodles.target_cm;
		
		if (array_length(cuts) == 0) return 0;
		
		var sheet_length = 20;
		
		var prev = 0;
		var total_error = 0;
		var segment_count = 0;
		
		// segmentos intermedios
		for (var i = 0; i < array_length(cuts); i++) {
			
			var current = cuts[i];
			var segment = current - prev;
			
			total_error += abs(segment - target);
			
			prev = current;
			segment_count++;
			
		}
		
		// último segmento
		var last_segment = sheet_length - prev;
		total_error += abs(last_segment - target);
		segment_count++;
		
		// penalizar pocos cortes
		var expected_segments = sheet_length / target;
		
		var coverage_penalty = clamp(segment_count / expected_segments, 0, 1);
		
		var max_error = expected_segments * target;
		var accuracy = clamp(1 - (total_error / max_error), 0, 1);
		
		return accuracy * coverage_penalty;

	}


}