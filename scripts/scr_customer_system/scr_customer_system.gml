function CustomerSystem() constructor {

    function init() {
		
        customers = [];
        active_customer = noone;
		
		current_interaction = noone;
		current_review_customer = noone;

        active_orders = array_create(3, noone);

        spawn_timer = 0;
        spawn_interval = 8;
        max_customers = 2;

        customer_wait_time = 30;

        station_x = 0;
        station_y = 0;
		queue_spacing = 0;
        queue_start_x = 0;
        queue_start_y = 0;
		wait_start_x = 0;
		wait_start_y = 0;
		wait_spacing = 55;

    }

	function refresh_station_anchor() {

	    var qs = instance_find(obj_queue_spot, 0);

	    if (qs != noone) {
	        queue_start_x = qs.x;
	        queue_start_y = qs.y;
	        queue_spacing = qs.spacing;
	    }
		
	    var st = instance_find(obj_st_order, 0);

	    if (st != noone) {
	        station_x = st.x;
	        station_y = st.y;
	    }		
		
		var ws = instance_find(obj_wait_spot, 0);
		
		if (ws != noone) {
			wait_start_x = ws.x;
			wait_start_y = ws.y;
		}
		
	}		


	// Updates

    function update(_dt) {
        refresh_station_anchor();
        update_spawning(_dt);
        cleanup();
        update_queue_targets();
        update_active_customer();
		update_foodwait_position();
    }

    function should_update(_current_station) {
        return true;
    }

    function update_spawning(_dt) {
        spawn_timer -= _dt;

        if (spawn_timer > 0) return;

        if (array_length(customers) < max_customers) {
            spawn_customer();
        }

        spawn_timer = spawn_interval;
    }

    function update_queue_targets() {
        var queue_index = 0;

        for (var i = 0; i < array_length(customers); i++) {

            var c = customers[i];

            if (!instance_exists(c)) continue;
            if (c == active_customer) continue;
			if (c.state == CUSTOMER_STATE.WALK && c.has_order) continue;
            if (c.state == CUSTOMER_STATE.LEAVE 
			|| c.state == CUSTOMER_STATE.DONE
			|| c.state == CUSTOMER_STATE.WAIT_FOOD) continue;

            var tx = queue_start_x + queue_index * queue_spacing;
            var ty = queue_start_y;

            c.target_x = tx;
            c.target_y = ty;

            if (c.state == CUSTOMER_STATE.SPAWN) {
                c.state = CUSTOMER_STATE.WALK;
            }

            queue_index++;
        }
    }
	
	function update_foodwait_position() {
		
		var index = 0;
		
		for (var i = 0; i < array_length(customers); i++) {
			
			var c = customers[i];
			if (!instance_exists(c)) continue;
			if (!c.has_order) continue;
			if (c.state != CUSTOMER_STATE.WAIT_FOOD) continue;
			
			c.target_x = wait_start_x;
			c.target_y = wait_start_y + index * wait_spacing;
			
			index++;
			
			
		}
		
	}
	
	
	// Customers

    function spawn_customer() {
		
		var sa = instance_find(obj_spawn_anchor, 0);
		if (sa == noone) return;
		
        var spawn_x = sa.x
        var spawn_y = sa.y + 64;

        var npc = instance_create_layer(spawn_x, spawn_y, "Instances", obj_cx_npc);

        npc.target_x = spawn_x;
        npc.target_y = spawn_y;

        npc.state = CUSTOMER_STATE.QUEUE;
        npc.wait_timer = customer_wait_time;
        npc.locked = false;
		npc.has_order = false;
		
		npc.portrait_index_id = irandom(sprite_get_number(spr_customer_npc) - 1);
		npc.order_dialog_lines = create_spawn_dialog_lines();
		npc.pending_order = generate_order();

        array_push(customers, npc);
    }		

    function update_active_customer() {
	
        // invalidar si ya no sirve
        if (instance_exists(active_customer)) {

            if (active_customer.state == CUSTOMER_STATE.LEAVE ||
                active_customer.state == CUSTOMER_STATE.DONE) {

                active_customer = noone;
            }
        }

        // asignar nuevo
        if (active_customer == noone) {

            for (var i = 0; i < array_length(customers); i++) {

                var c = customers[i];
				if (!instance_exists(c)) continue;
				if (c.has_order) continue;
                if (!instance_exists(c)) continue;
                if (c.state == CUSTOMER_STATE.LEAVE 
				|| c.state == CUSTOMER_STATE.DONE
				|| c.state == CUSTOMER_STATE.WAIT_FOOD) continue;
                if (c.locked) continue;

                activate_customer(c);
                break;
            }
        }
    }

    function activate_customer(_c) {

        if (_c == noone || !instance_exists(_c)) return;

        active_customer = _c;

        _c.wait_timer = customer_wait_time;
        _c.target_x = station_x;
        _c.target_y = station_y;

        _c.state = CUSTOMER_STATE.WALK;
    }

    function get_active_customer() {

        if (!instance_exists(active_customer)) return noone;
        if (active_customer.state != CUSTOMER_STATE.WAIT) return noone;
        if (active_customer.locked) return noone;

        return active_customer;
    }
		
	
	// Orders	

    function confirm_order(_c) {

        if (_c == noone || !instance_exists(_c)) return;

        var slot = get_free_order_slot();

        if (slot == -1) {
            _c.state = CUSTOMER_STATE.LEAVE;
            _c.locked = false;

            if (_c == active_customer) active_customer = noone;
            return;
        }

        active_orders[slot] = generate_order();

        _c.state = CUSTOMER_STATE.DONE;
        _c.locked = false;

        if (_c == active_customer) active_customer = noone;
    }
	
	function generate_order() {
	
		return {
			
			noodles: {
				type: choose(
					NOODLE_ID.WHEAT, 
					NOODLE_ID.CURSED, 
					NOODLE_ID.BONE, 
					NOODLE_ID.STONE
				),
				target_cm: choose(1, 2, 4)
			},
			
			broth: choose(
				BROTH_ID.CHICKEN, 
				BROTH_ID.ROTTEN
			),
			
			meat: {
				type: choose(
					MEAT_ID.BEEF, 
					MEAT_ID.BUG, 
					MEAT_ID.DRAGON
					),
				target_tender: irandom_range(0, 5)
			},
			
			egg: choose(
				EGG_TYPE.NORMAL,
				EGG_TYPE.ROTTEN,
				EGG_TYPE.FIRE,
				EGG_TYPE.WATER,
				EGG_TYPE.GOLD,
				EGG_TYPE.SHADOW
			),
			
	        veggies: {
	            type: choose(
	                VEGGIE_TYPE.CARROT,
	                VEGGIE_TYPE.MUSHROOM,
	                VEGGIE_TYPE.BOK_CHOY
	            ),
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
		}
	}

    function get_free_order_slot() {

        for (var i = 0; i < array_length(active_orders); i++) {
            if (active_orders[i] == noone) return i;
        }

        return -1;
    }
	
	
	// Interactions 
	
	function get_current_interaction() {
		return current_interaction;	
	}
	
	function create_spawn_dialog_lines() {
		var pool = global.order_dialog_db;
		return pool[irandom(array_length(pool) -1)];
	}
	
	function create_interaction(_c) {
		
		var pack = _c.order_dialog_lines;
		if (is_undefined(pack)) {
			pack = create_spawn_dialog_lines();
			_c.order_dialog_lines = pack;
		}
		
		var pending_order = _c.pending_order;
		if (is_undefined(pending_order)) {
			pending_order = generate_order();
			_c.pending_order = pending_order;
		}
		
		return {
			customer: _c,
			dialog_lines: pack,
			preview_order: pending_order,
			dialog_index: 0,
			done: false,
		}
	}
	
    function start_interaction(_c) {

        if (_c == noone) return false;
        if (_c != active_customer) return false;
        if (_c.state != CUSTOMER_STATE.WAIT) return false;

        _c.locked = true;
        _c.state = CUSTOMER_STATE.INTERACT;
		
		current_interaction = create_interaction(_c);
		
        return true;
    }
	
	function finish_interaction() {
		
		if (current_interaction == noone) return;
		
		var _c = current_interaction.customer;
		
		var order = generate_order();
		if (is_undefined(order)) {
			order = generate_order();
		}
		_c.order = order;
		_c.has_order = true;
		_c.pending_order = generate_order();
		
		add_active_ticket(order, _c);

		_c.locked = false;
		_c.state = CUSTOMER_STATE.WALK;
		
		var w_spot = instance_find(obj_wait_spot, 0);
		if (w_spot != noone) {
			_c.target_x = w_spot.x;
			_c.target_y = w_spot.y;
		}
		
		if (_c == active_customer) active_customer = noone;

		current_interaction = noone;
		obj_game.current_ticket = obj_game.tickets.create_ticket(order);
		
	}
		
	function try_open_review(_c) {
		
		if (obj_game.current_modal_ui != noone) return;
		if (_c == noone) return;
		if (!instance_exists(_c)) return;
		if (_c.state != CUSTOMER_STATE.WAIT_FOOD) return;
		
		current_review_customer = _c;
		
		obj_game.open_modal_ui(obj_review_ui);
		show_debug_message("OPEN REVIEW: " + string(_c) + " | portrait: " + string(_c.portrait_index_id));
	}
	
	function cancel_interaction() {
		
		if (current_interaction == noone) return;
		
		var _c = current_interaction.customer;
		if (instance_exists(_c)) {
			if (_c.state == CUSTOMER_STATE.INTERACT)	{
				_c.state = CUSTOMER_STATE.WAIT;		
			}
			_c.locked = false;
		}
		current_interaction = noone;
	}
	
	function serve_bowl(_bowl_index) {
	
		var c = current_review_customer;
		
		if (!instance_exists(c)) return;
		
		var order = c.order;
		if (is_undefined(order)) return;
		
		var bowl = obj_game.bowls.bowls[_bowl_index];
		if (is_undefined(bowl)) return;
		
		// evaluar
		var bowl_score = obj_game.order_system.evaluate_bowl(bowl, order);
		
		show_debug_message("SCORE: " + string(bowl_score));
		
		var stars = round(bowl_score * 5 * 2) / 2;
		
		show_debug_message("STARS: " + string(stars));
		
		obj_game.bowls.reset_bowl(_bowl_index);
		
		c.review_stars = stars;
		c.review_done = true
		
		// eliminar ticket
		remove_ticket_for_customer(c);

		
	}
	
	// Tickets
	
	function add_active_ticket(_order, _customer) {
	
		if (array_length(obj_game.tickets.tickets) >= 3) return false;
		
		var ticket = obj_game.tickets.create_ticket(_order, _customer);
		array_push(obj_game.tickets.tickets, ticket);
		rebuild_active_orders_from_tickets();
		
		return true;
	}
	
	function remove_ticket_for_customer(_customer) {
		
		var tickets = obj_game.tickets.tickets;
		
		for (var i = 0; i < array_length(tickets); i++) {
			
			var t = tickets[i];
			if (t == noone) continue;
			
			if (t.customer == _customer) {
				array_delete(obj_game.tickets.tickets, i, 1);
				break;
			}
		}
		rebuild_active_orders_from_tickets();
	}
	
	function rebuild_active_orders_from_tickets() {
		
		active_orders = array_create(3, noone);
		
		var tickets = obj_game.tickets.tickets;
		var max_copy = min(array_length(tickets), array_length(active_orders));
		
		for (var i = 0; i < max_copy; i++) {
			var t = tickets[i];
			if (t == noone) continue;
			active_orders[i] = t.order;
		}
	}


	// Cleanse
	
    function cleanup() {

        for (var i = array_length(customers) - 1; i >= 0; i--) {

            var c = customers[i];

            if (!instance_exists(c)) {
                array_delete(customers, i, 1);
                continue;
            }

            if (c.state == CUSTOMER_STATE.LEAVE) {

                if (c.x < -100 || c.y > room_height + 100) {

                    if (c == active_customer) active_customer = noone;

                    instance_destroy(c);
                    array_delete(customers, i, 1);
                }
            }
        }
    }
}
