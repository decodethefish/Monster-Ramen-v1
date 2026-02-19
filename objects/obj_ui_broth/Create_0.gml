
potw = sprite_get_width(spr_pot);
poth = sprite_get_height(spr_pot);


// caldos
broths = []
var b;

b = {
	x_start: 60,
	y_start: 260,
	x: 60,
	y: 260,
	sprite: spr_broth,
	recipe_id: BROTH_ID.CHICKEN,
	dragging: false
};
array_push(broths, b);	

b = {
	x_start: 60,
	y_start: 100,
	x: 60,
	y: 100,
	sprite: spr_broth_rotten,
	recipe_id: BROTH_ID.ROTTEN,
	dragging: false
};
array_push(broths, b);	



// interruptores

switches = [];

for (var i = 0; i < array_length(obj_game.broth.pots); i++) {
	switches[i] = {
		pot_index: i,
		r: 15,
		x: obj_game.broth.pot_positions[i].x,
		y: obj_game.broth.pot_positions[i].y + 100
	};
}



// Tazones

bowls = [];

for (var i = 0; i < 3; i++) {
    var bx = 570;
    var by = 120 + i * 60;

    var bw = instance_create_layer(bx, by, "UI", obj_bowl_ui);

    bowls[i] = bw;

    bw.x_start = bx;
    bw.y_start = by;
	
	bw.bowl_index = i;
	
}