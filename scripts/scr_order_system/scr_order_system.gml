function OrderSystem() constructor {
	
	
	function evaluate_bowl(_bowl, _order) {
		
		if (_order == noone) return 0;
		
		var current_score = 0;
		var max_score = 5;
		
		// Broth
		if (_bowl.has_broth) {
    
		    if (_bowl.broth_id == current_order.broth) {
        
		        if (_bowl.broth_state != POT_STATE.BURNED) {
		            current_score += 1;
		        }
		    }
		}		
			
		// Noodles
		if (_bowl.noodles != noone) {
			
			if (_bowl.noodles.type == current_order.noodles.type) {
				current_score += _bowl.noodles.quality;	
			}
		}
		
		// Meat
		if (_bowl.meat != noone) {
			
			if (_bowl.meat.type == current_order.meat.type) {
				current_score += (_bowl.meat.tender_quality / 3);
			}
		}
		
		// Eggs
		if (_bowl.egg == _order.egg) {
			current_score += 1;	
		}
		
		// Veggies
		if (_bowl.veggies != noone) {
		
			if (_bowl.veggies.veg_type == current_order.veggies.type) {
				current_score += 1;		
			}
		}
		
		return current_score / max_score;
		
	
	}


}