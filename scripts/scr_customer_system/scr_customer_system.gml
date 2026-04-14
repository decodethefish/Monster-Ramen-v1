function CustomerSystem() constructor {
	
	function init() {
		
		spawn_timer = 2;
		
		active_customer = noone;
		active_orders = array_create(3, noone);	
		
		customers = [];
		spawn_timer = 0;
		max_active_orders = 3;
		max_customers = 2;
		
	}
	
	function should_update(_current_station) {
		return true;
	}	
	
	function update(_dt) {

	    spawn_timer -= _dt;
		
		// Spawnear cliente
	    if (spawn_timer <= 0) {

	        if (array_length(customers) < max_customers) {
	            spawn_customer();
	        }

	        spawn_timer = 8;
	    }

	    cleanup();
		
		// Asignar cliente
		if (active_customer == noone) {
			
			for (var i = 0; i < array_length(customers); i++) {
			
				var c = customers[i];
				
				if (!instance_exists(c)) continue;
				if (c.state != CUSTOMER_STATE.WAIT) continue;
				if (c.locked) continue;
				
				active_customer = c;
				break;
			}
		}
	}
	
	function update_spawning(_dt) {
	
		spawn_timer -= _dt;
		
		if (spawn_timer <= 0) {
		
			if (array_length(customers) < max_customers) {
				spawn_customer();	
			}
		
		spawn_timer = 8;
		
		}
	}
	
	function update_customers(_dt) {

	    for (var i = array_length(customers) - 1; i >= 0; i--) {

	        var c = customers[i];

	        if (c.state == CUSTOMER_STATE.LEAVE && c.x < -50) {
	            array_delete(customers, i, 1);
	        }
	    }
	}

	function spawn_customer() {
		
		var st = instance_find(obj_st_order, 0);
		
		if (st == noone) {
			show_debug_message("NO STATION FOUND");
			return;
		}
		
	    var npc = instance_create_layer(100, 400, "Instances", obj_cx_npc);
		
		npc.target_x = st.x;
		npc.target_y = st.y;
		
		npc.state = CUSTOMER_STATE.SPAWN;

	    array_push(customers, npc);
		
		show_debug_message("TARGET: " + string(st.x) + ", " + string(st.y));
	}
	
	function get_waiting_customer() {
	
		for (var i = 0; i < array_length(customers); i++) {
			
			var c = customers[i];
			
			if (c.state == CUSTOMER_STATE.WAIT && !c.locked) {
				return c;	
			}
		}
		
		return noone;
	}
	
	function start_interaction(c) {
		
		if (c == noone) return false;
		
		c.locked = true;
		c.state = CUSTOMER_STATE.INTERACT;
		
		return true;
		
	}
	
	function confirm_order(c) {
		
		if (c == noone) return;
		
		var slot = get_free_order_slot();
		
		if (slot == -1) {
			// si no hay espacio, podemos hacer que se moleste o algo xd
			c.state =	CUSTOMER_STATE.LEAVE;
			return;
		}
		
		var order = generate_order();
		
		active_orders[slot] = order;
		c.state = CUSTOMER_STATE.DONE;
		
	}
		
	function get_free_order_slot() {
		
		for (var i = 0; i < array_length(active_orders); i++) {
			if (active_orders[i] == noone) return i;
		}
		
		return -1;
	}
	
	function get_customer_at_station(_x, _y, _range) {
	
		var best = noone;
		var best_dist = _range;
		
		for (var i = 0; i < array_length(customers); i++) {
		
			var c = customers[i];
			
			if (!instance_exists(c)) continue;
			if (c.state != CUSTOMER_STATE.WAIT) continue;
			if (c.locked) continue;
			
			var d = point_distance(c.x, c.y, _x, _y);
			
			if (d < best_dist) {
				best = c;
				best_dist = d;
			}
		}
		
		return best;
	}
	
	function cleanup() {

	    for (var i = array_length(customers) - 1; i >= 0; i--) {

	        var c = customers[i];

	        if (!instance_exists(c)) {
	            array_delete(customers, i, 1);
	            continue;
	        }

	        if (c.state == CUSTOMER_STATE.LEAVE && c.x < -50) {
	            instance_destroy(c);
	            array_delete(customers, i, 1);
	        }
	    }
	}
	
	
}
