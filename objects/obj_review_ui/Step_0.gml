var c = obj_game.review.current_review_customer;

if (!instance_exists(c))  exit;

// -------- CERRAR UI ---------
if (c.review_done) {
	stars = c.review_stars;
	review_ready = true;
}

if (review_ready && keyboard_check_pressed(vk_space)) {
	c.state = CUSTOMER_STATE.LEAVE;
	c.locked = false;
	c.target_x = c.x;
	c.target_y = room_height + 100;
	
	obj_game.review.close_review();
	obj_game.close_modal_ui();
}