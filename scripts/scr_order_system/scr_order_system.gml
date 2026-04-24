function OrderSystem() constructor {
	
	active_tickets = [];
	preview_ticket = noone;
	max_active_orders = 3;
	
	// --------- ORDENES ----------
    function generate_order() {
        return {
            noodles: {
                type: choose(NOODLE_ID.WHEAT, NOODLE_ID.CURSED, NOODLE_ID.BONE, NOODLE_ID.STONE),
                target_cm: choose(1, 2, 4)
            },
            broth: choose(BROTH_ID.CHICKEN, BROTH_ID.ROTTEN),
            meat: {
                type: choose(MEAT_ID.BEEF, MEAT_ID.BUG, MEAT_ID.DRAGON),
                target_tender: irandom_range(0, 5)
            },
            egg: choose(EGG_TYPE.NORMAL, EGG_TYPE.ROTTEN, EGG_TYPE.FIRE, EGG_TYPE.WATER, EGG_TYPE.GOLD, EGG_TYPE.SHADOW),
            veggies: {
                type: choose(VEGGIE_TYPE.CARROT, VEGGIE_TYPE.MUSHROOM, VEGGIE_TYPE.BOK_CHOY),
                result: choose(
                    VEGGIE_RESULT.BLEEDING,
                    VEGGIE_RESULT.MAGICAL,
                    VEGGIE_RESULT.SPECTRAL,
                    VEGGIE_RESULT.CORRUPT,
                    VEGGIE_RESULT.CURSED,
                    VEGGIE_RESULT.DARK,
                    VEGGIE_RESULT.SPECTRAL,
                    VEGGIE_RESULT.ALCHEMICAL,
                    VEGGIE_RESULT.PARADOX,
                    VEGGIE_RESULT.ETERNAL
                )
            }
        };
    }
	
	function can_take_more_orders() {
		return array_length(active_tickets) < max_active_orders;
	}
	
	// --------- TICKETS ----------
	function create_ticket(_order, _customer) {
		return {
			order: _order,
			customer: _customer,
			draw_x: 0,
			draw_y: 0,
		}
	}
		
	function add_ticket(_order, _customer) {
		if (!can_take_more_orders()) return false;
		array_push(active_tickets, create_ticket(_order, _customer));
		return true;
	}
		
	function remove_ticket_for_customer(_customer) {
		for (var i = 0; i < array_length(active_tickets); i++)	{
			var t =active_tickets[i];
			if (t = noone) continue;
			if (t.customer == _customer) {
				array_delete(active_tickets, i, 1)	;
				break;
			}
		}
	}
	
	function get_tickets() {
		return active_tickets;	
	}
	
	function begin_preview(_order, _customer) {
		preview_ticket = create_ticket(_order, _customer);
	}
	
	function get_preview_ticket() {
		return preview_ticket;	
	}
	
    function assign_order_to_customer(_customer, _order) {
        if (_customer == noone) return false;
        if (!instance_exists(_customer)) return false;
        if (!can_take_more_orders()) return false;

        _customer.order = _order;
        _customer.has_order = true;

        add_ticket(_order, _customer);
        clear_preview();
        return true;
    }
	
	// --------- EVALUACIONES ----------
	function evaluate_bowl(_bowl, _order) {
		if (_order == noone)	 return 0;
		
		var current_score = 0;
		var max_score = 5;

        if (_bowl.has_broth) {
            if (_bowl.broth_id == _order.broth && _bowl.broth_state != POT_STATE.BURNED) current_score += 1;
        }

        if (_bowl.has_noodles && !is_undefined(_bowl.noodle_data)) {
            current_score += evaluate_noodles(_bowl.noodle_data, _order.noodles);
        }

        if (_bowl.has_meat && !is_undefined(_bowl.meat_data)) {
            current_score += evaluate_meat(_bowl.meat_data, _order.meat);
        }

        if (_bowl.has_egg && _bowl.egg_type == _order.egg) current_score += 1;
        if (_bowl.has_veggie && _bowl.veg_type == _order.veggies.type) current_score += 1;

        return current_score / max_score;		
	}
	
    function evaluate_meat(_meat_data, _order_meat) {
        if (_meat_data == noone) return 0;
        if (_order_meat == noone) return 0;
        if (_meat_data.type != _order_meat.type) return 0;

        var target = _order_meat.target_tender;
        var times = _meat_data.time_per_zone;
        var time_in_target = times[target];
        var total = 0;

        for (var i = 0; i < array_length(times); i++) total += times[i];
        if (total <= 0) return 0;

        var ratio = time_in_target / total;
        var tender_score = 0.2;
        if (ratio >= 0.7) tender_score = 1;
        else if (ratio >= 0.4) tender_score = 0.6;

        var data = obj_game.meat.meats_data[_meat_data.type];
        var t = _meat_data.cook_time;
        var ready = data.cook_ready_time;
        var end_t = data.cook_time;

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

        for (var i = 0; i < array_length(cuts); i++) {
            var current = cuts[i];
            var segment = current - prev;
            total_error += abs(segment - target);
            prev = current;
            segment_count++;
        }

        var last_segment = sheet_length - prev;
        total_error += abs(last_segment - target);
        segment_count++;

        var expected_segments = sheet_length / target;
        var coverage_penalty = clamp(segment_count / expected_segments, 0, 1);
        var max_error = expected_segments * target;
        var accuracy = clamp(1 - (total_error / max_error), 0, 1);

        return accuracy * coverage_penalty;
    }

}