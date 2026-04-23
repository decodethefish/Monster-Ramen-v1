var c = obj_game.customers.current_review_customer;

if (instance_exists(c)) {
	
	if (c.review_done) {
		stars = c.review_stars;
		review_ready = true;
	}
}