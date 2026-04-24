y_anchor = 40;
spacing = 80;

hover_index = -1;
preview_offset = 0;
preview_active = false;
preview_index = -1;

// --------- FUNCIONES ----------
function cm_to_index(_cm) {
	switch (_cm)	 {
		case 1: return 0;
		case 2: return 1;
		case 4: return 2;
	}
	return 0;
}

function draw_ticket_details(_ticket, _x, _y) {
	if (!is_struct(_ticket)) return;
	
	var o = _ticket.order;
	if (is_undefined(o)) return;
	
	draw_sprite(spr_tk_base, 0, _x, _y);
	draw_sprite(spr_tk_broth, o.broth -1, _x, _y);
	draw_sprite(spr_tk_eggs, o.egg, _x, _y);
	
	var spr = -1;
	switch (o.veggies.type) {
		case VEGGIE_TYPE.CARROT: spr = spr_tk_carrot; break;
		case VEGGIE_TYPE.MUSHROOM: spr = spr_tk_mush; break;
		case VEGGIE_TYPE.BOK_CHOY: spr = spr_tk_bok; break;
	}
	if (spr != -1) draw_sprite(spr, o.veggies.result + 1, _x, _y);
	
	draw_sprite(spr_tk_noodles, 0, _x, _y);
	draw_sprite(spr_tk_centimeters, cm_to_index(o.noodles.target_cm), _x, _y);
    draw_sprite(spr_tk_runes, o.noodles.type - 1, _x, _y);

    draw_sprite(spr_tk_meats, o.meat.type - 1, _x, _y);
    draw_sprite(spr_tk_tender, o.meat.target_tender, _x, _y);
}