function CustomerSystem() constructor {

    function init() {
        customers = [];
        active_customer = noone;
        current_interaction = noone;

        spawn_timer = 0;
        spawn_interval = 8;
        max_customers = 2;

        customer_wait_time = 30;
		customer_food_wait_time = 180;

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
		if (st != noone ) {
			station_x = st.x;
			station_y = st.y;
		}
		
		var ws = instance_find(obj_wait_spot, 0);
		if (ws != noone) {
			wait_start_x = ws.x;
			wait_start_y = ws.y;
		}
	}
	
	// --------- UPDATES ----------
    function update(_dt) {
        refresh_station_anchor();
        update_spawning(_dt);
        cleanup();
		
        update_active_customer();
        update_queue_targets();  
		
        update_foodwait_position();
		update_state_transitions(_dt);
    }
	
    function should_update(_current_station) {
        return true;
    }

    function update_spawning(_dt) {
        spawn_timer -= _dt;
        if (spawn_timer > 0) return;

        if (array_length(customers) < max_customers) spawn_customer();
        spawn_timer = spawn_interval;
    }
		
	function update_queue_targets() {
	    var queue_index = 0;

	    for (var i = 0; i < array_length(customers); i++) {
	        var c = customers[i];
	        if (!instance_exists(c)) continue;
	        if (c == active_customer) continue;
	        if (c.has_order) continue;
	        if (c.state == CUSTOMER_STATE.LEAVE || c.state == CUSTOMER_STATE.DONE) continue;
	        if (c.state == CUSTOMER_STATE.WAIT || c.state == CUSTOMER_STATE.INTERACT || c.state == CUSTOMER_STATE.WAIT_FOOD) continue;

	        c.target_x = queue_start_x + queue_index * queue_spacing;
	        c.target_y = queue_start_y;

	        if (c.state == CUSTOMER_STATE.SPAWN) {
	            c.state = CUSTOMER_STATE.WALK;
	        } else if (c.state == CUSTOMER_STATE.QUEUE) {
	            var needs_reposition = (point_distance(c.x, c.y, c.target_x, c.target_y) > 2);
	            if (needs_reposition) c.state = CUSTOMER_STATE.WALK;
	        }
	        queue_index++;
	    }
	}
	
	function update_foodwait_position() {
		var index = 0;
		
		for  (var i = 0; i < array_length(customers); i++) {
			var c = customers[i];
			if (!instance_exists(c)) continue;
			if (!c.has_order) continue;
			if (c.state != CUSTOMER_STATE.WAIT_FOOD) continue;
			
			c.target_x = wait_start_x;
			c.target_y = wait_start_y + index * wait_spacing;
			index++;
		}
	}
	
	// --------- CUSTOMERS ----------
	function spawn_customer() {
		var sa = instance_find(obj_spawn_anchor, 0)	;
		if (sa == noone) return;
		
		var spawn_x = sa.x;
		var spawn_y = sa.y + 64;
		
		var npc = instance_create_layer(spawn_x, spawn_y, "Instances", obj_cx_npc);
		npc.target_x = spawn_x;
		npc.target_y = spawn_y;
		npc.state = CUSTOMER_STATE.QUEUE;
		npc.wait_timer = customer_wait_time;
		npc.locked = false;
		npc.has_order = false;
		npc.portrait_index_id = irandom(sprite_get_number(spr_customer_npc) -1);
		npc.order_dialog_lines = create_spawn_dialog_lines();
		npc.pending_order = obj_game.orders.generate_order();
		
		array_push(customers, npc);
	}
	
	function update_active_customer() {
		if (instance_exists(active_customer))	 {
			if (active_customer.state == CUSTOMER_STATE.LEAVE || active_customer.state == CUSTOMER_STATE.DONE) {
				active_customer = noone;
			} else {
				// Garantiza que el cliente activo siempre tenga destino/estado de avance hacia estación.
				active_customer.target_x = station_x;
				active_customer.target_y = station_y;
				if (active_customer.state == CUSTOMER_STATE.SPAWN || active_customer.state == CUSTOMER_STATE.QUEUE) {
					active_customer.state = CUSTOMER_STATE.WALK;
				}
			}
		}
	
		if (!instance_exists(active_customer)) {
			for (var i = 0; i < array_length(customers); i++) {
				var c = customers[i]	;
				if (!instance_exists(c)) continue;
			
				if (c.state != CUSTOMER_STATE.QUEUE) continue;
				if (c.locked) continue;
			
				activate_customer(c);
				break;
			}
		}
	}
	
	function activate_customer(_c) {
		if (_c == noone || !instance_exists(_c)) return;
		
		active_customer = _c;

		_c.target_x = station_x;
		_c.target_y = station_y;
		if (_c.state == CUSTOMER_STATE.QUEUE) _c.state = CUSTOMER_STATE.WALK;
	}
		
	function get_active_customer() {
		if (!instance_exists(active_customer)) return noone;
		if (active_customer.state != CUSTOMER_STATE.WAIT) return noone;
		if (active_customer.locked) return noone;
		return active_customer;
	}
	
	function get_ui_timers() {
		var timers = [];

		for (var i = 0; i < array_length(customers); i++) {
			var c = customers[i];
			if (!instance_exists(c)) continue;

			var max_time = 0;
			var time_left = 0;
			switch (c.state) {
				case CUSTOMER_STATE.WAIT:
					max_time = customer_wait_time;
					time_left = max(0, c.wait_timer);
				break;

				case CUSTOMER_STATE.WAIT_FOOD:
					max_time = customer_food_wait_time;
					time_left = max(0, c.food_wait_timer);
				break;
			}

			if (max_time <= 0) continue;

			array_push(timers, {
				customer: c,
				time_left: time_left,
				time_max: max_time,
				ratio: clamp(time_left / max_time, 0, 1),
			});
		}

		return timers;
	}
	
	function update_state_transitions(_dt) {
		for (var i = 0; i < array_length(customers); i++) {
			var c = customers[i];
			if (!instance_exists(c)) continue;
		
			var dist = point_distance(c.x, c.y, c.target_x, c.target_y);
			var at_target = (dist <= 2);
		
			switch (c.state) {
				case CUSTOMER_STATE.WALK:
					if (at_target) {
						if (c.has_order) {
							c.state = CUSTOMER_STATE.WAIT_FOOD;
							c.food_wait_timer = customer_food_wait_time;
						} else if (c == active_customer) {
							c.state = CUSTOMER_STATE.WAIT;
						} else {
							c.state = CUSTOMER_STATE.QUEUE;
						}
					}
				break;
			
				case CUSTOMER_STATE.WAIT:
					if (c != active_customer && !c.locked) {
						c.state = CUSTOMER_STATE.QUEUE;
						break;
					}

					if (!c.locked) {
						c.wait_timer -= _dt;
						if (c.wait_timer <= 0) c.state = CUSTOMER_STATE.LEAVE;
					}
				break;

				case CUSTOMER_STATE.WAIT_FOOD:
					c.food_wait_timer -= _dt;
					if (c.food_wait_timer <= 0) {
						if (c.has_order) {
							obj_game.orders.remove_ticket_for_customer(c);
							c.has_order = false;
						}

						c.locked = false;
						c.state = CUSTOMER_STATE.LEAVE;
					}
				break;

				case CUSTOMER_STATE.DONE:
					c.state = CUSTOMER_STATE.LEAVE;
				break;
			}
		}
	}

	
	// --------- INTERACTIONS ----------
	function get_current_interaction() {
		return current_interaction;
	}
	
	function create_spawn_dialog_lines() {
		var pool = global.order_dialog_db;
		return pool[irandom(array_length(pool) -1)];
	}
	
	function create_interaction(_c) {
		var dialog_pack = _c.order_dialog_lines;
		if (is_undefined(dialog_pack)) {
			dialog_pack = create_spawn_dialog_lines();
			_c.order_dialog_lines = dialog_pack;
		}
	
	var pending_order = _c.pending_order;
	if (is_undefined(pending_order)) {
		pending_order = obj_game.orders.generate_order();
		_c.pending_order = pending_order;
	}
	
	return {
		customer: _c,
		dialog_lines: dialog_pack,
		preview_order: pending_order,
		dialog_index: 0,
		done: false,
	}
	
	
		

	
}
	
	function start_interaction(_c) {
		if (_c == noone)	 return false;
		if (_c != active_customer) return false;
		if (_c.state != CUSTOMER_STATE.WAIT) return false;
		
		_c.locked = true;
		_c.state = CUSTOMER_STATE.INTERACT;
		current_interaction = create_interaction(_c);
		return true;
	}
	
	function finish_interaction() {
		if (current_interaction == noone)	 return;
		
		var _c = current_interaction.customer;
		var order = current_interaction.preview_order;
		
		if (is_undefined(order)) order = obj_game.orders.generate_order();
		
		var accepted = obj_game.orders.assign_order_to_customer(_c, order);
		if (!accepted) {
			_c.state = CUSTOMER_STATE.LEAVE;
			_c.locked = FALSE;
			if (_c == active_customer) active_customer = noone;
			current_interaction = noone;
			return;
		}
		
		_c.pending_order = obj_game.orders.generate_order();
		_c.locked = false;
		_c.state = CUSTOMER_STATE.WALK;
		
		var w_spot = instance_find(obj_wait_spot, 0);
		if (w_spot != noone) {
			_c.target_x = w_spot.x;
			_c.target_y = w_spot.y;
		}
		
		if (_c == active_customer) active_customer = noone;
		
		current_interaction = noone;
	}
	 
	function try_open_review(_c) {
		return obj_game.review.open_for_customer(_c);
	}
	
	function cancel_interacton() {
		if (current_interaction == noone) return;
		
		var _c = current_interaction.customer;
		if (instance_exists(_c)) {
			if (_c.state == CUSTOMER_STATE.INTERACT) _c.state = CUSTOMER_STATE.WAIT;
			_c.locked = false;
		}
		obj_game.orders.clear_preview();
		current_interaction = noone;
	}
	
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
                    obj_game.orders.remove_ticket_for_customer(c);
                    instance_destroy(c);
                    array_delete(customers, i, 1);
                }
            }
        }
    }
}