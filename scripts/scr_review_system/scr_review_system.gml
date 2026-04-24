function ReviewSystem() constructor {
	
	current_customer = noone;
	current_stars = 0;
	review_ready = false;
	
	// --------- ABRIR REVIEW ----------
	function can_open_for_customer(_customer) {
		if (_customer = noone) return false;
		if (!instance_exists(_customer)) return false;
		if (_customer.state != CUSTOMER_STATE.WAIT_FOOD) return false;
		if (obj_game.current_modal_ui != noone) return false;
		return true;
	}
	
	function open_for_customer(_customer) {
		if (!can_open_for_customer(_customer)) return false;
		
		current_customer = _customer;
		review_ready = false;
		current_stars = 0;
		
		obj_game.open_modal_ui(obj_review_ui);
		return true;
	}
	
	// --------- SERVIR ----------
	function is_active() {
		return instance_exists(current_customer);
	}
	
	function get_current_customer() {
		return current_customer;
	}
	
	function try_serve_bowl(_bowl_index) {
		if (!is_active()) return false;
		
		var c = current_customer;
		var order = c.order;
		if (is_undefined(order)) return false;
		
		var bowl = obj_game.bowls.bowls[_bowl_index];
		if (is_undefined(bowl)) return false;
		
		var bowl_score = obj_game.orders.evaluate_bowl(bowl, order);
		var stars = round(bowl_score * 5 * 2) / 2;
		
		obj_game.bowls.reset_bowl(_bowl_index);
		
		c.review_stars = stars;
		c.review_done = true;
		c.has_order = false;
		
		current_stars = stars;
		review_ready = true;
		
		obj_game.orders.remove_ticket_for_customer(c);
		
		return true;
	}
	
	// --------- CERRAR REVIEW ----------
	function close_review() {
		current_customer = noone;
		review_ready = false;
		current_stars = 0;
	}
	
}