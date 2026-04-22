function TicketSystem() constructor {
	
	tickets = [];
	
	function create_ticket(_order) {
		
		return {
			order: _order
		};
		
	}
		
	function draw(_ticket, _x, _y) {
	
		if (is_undefined(_ticket)) return;
		if (_ticket == noone) return;
		if (is_struct(_ticket)) return;
		
		var o = _ticket.order;
		
		if (is_undefined(o)) return;
		
		// ---------------- BASE ----------------
		draw_sprite(spr_tk_base, 0, _x, _y);
		
		// ---------------- BROTH ----------------
		draw_sprite(spr_tk_broth, o.broth - 1, _x, _y);
		
		// ---------------- EGGS ----------------
		draw_sprite(spr_tk_eggs, o.egg, _x, _y);
		
		// ---------------- VEGGIES ----------------
		var spr;
		switch (o.veggies.type) {
			case VEGGIE_TYPE.CARROT : spr = spr_tk_carrot; break;
			case VEGGIE_TYPE.MUSHROOM : spr = spr_tk_mush; break;
			case VEGGIE_TYPE.BOK_CHOY : spr = spr_tk_bok; break;
		}
		
		if (spr != -1) {
			draw_sprite(spr, o.veggies.result, _x, _y );
		}
		
		// ---------------- NOODLES ----------------
		draw_sprite(spr_tk_noodles, 0, _x, _y);
		
		var cm_index = 0;
		if (o.noodles.target_cm == 2) cm_index = 1;
		if (o.noodles.target_cm == 24) cm_index = 2;
		
		draw_sprite(spr_tk_centimeters, cm_index, _x, _y);
		
		// ---------------- MEAT ----------------
		draw_sprite(spr_tk_meats, o.meat.type -1, _x, _y);
		
		draw_sprite(spr_tk_tender, o.meat.target_tender, _x, _y);
	}
	
}
