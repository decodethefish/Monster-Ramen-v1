function EggSystem() constructor {
	
	max_chickens = 5;
	active_chickens = 5;
	chickens = [];
	chicken_sprites = [];
	eggs = [];
	egg_data = [];
	caught_eggs = [];
	
	basket_x = 0;
	basket_y = 0;
	
	function init () {
		
		chickens = array_create(max_chickens);
		
		chickens[0] = {
			type: CHICKEN_TYPE.NORMAL,
			x_position: 0,
			move_dir: choose(-1,1),
			move_speed: 2,
			egg_timer: irandom_range(60,120)
		};
		chickens[1] = {
			type: CHICKEN_TYPE.FIRE,
			x_position: 0,
			move_dir: choose(-1,1),
			move_speed: 2,
			egg_timer: irandom_range(60,120)
		};
		chickens[2] = {
			type: CHICKEN_TYPE.WATER,
			x_position: 0,
			move_dir: choose(-1,1),
			move_speed: 2,
			egg_timer: irandom_range(60,120)
		};
		chickens[3] = {
			type: CHICKEN_TYPE.GOLD,
			x_position: 0,
			move_dir: choose(-1,1),
			move_speed: 2,
			egg_timer: irandom_range(60,120)
		};	
		chickens[4] = {
			type: CHICKEN_TYPE.SHADOW,
			x_position: 0,
			move_dir: choose(-1,1),
			move_speed: 2,
			egg_timer: irandom_range(60,120)
		};		
			
		chicken_sprites[CHICKEN_TYPE.NORMAL] = spr_egg_chicken_normal;
		chicken_sprites[CHICKEN_TYPE.FIRE]   = spr_egg_chicken_fire;
		chicken_sprites[CHICKEN_TYPE.WATER]  = spr_egg_chicken_water;
		chicken_sprites[CHICKEN_TYPE.GOLD]   = spr_egg_chicken_gold;
		chicken_sprites[CHICKEN_TYPE.SHADOW] = spr_egg_chicken_shadow;
		
		egg_data[EGG_TYPE.NORMAL] = {
			fall_speed: 4,
			spr_index: 0
		};
		egg_data[EGG_TYPE.ROTTEN] = {
			fall_speed: 5,
			spr_index: 1
		};
		egg_data[EGG_TYPE.FIRE] = {
			fall_speed: 6,
			spr_index: 2
		};		
		egg_data[EGG_TYPE.WATER] = {
			fall_speed: 7,
			spr_index: 3
		};
		egg_data[EGG_TYPE.GOLD] = {
			fall_speed: 8,
			spr_index: 4
		};
		egg_data[EGG_TYPE.SHADOW] = {
			fall_speed: 9,
			spr_index: 5
		};
		
		
	}
	
	function update () {
		
		var limit = 240;
		
		for (var i = 0; i < active_chickens; i++) {
			
			var ch = chickens[i];
			
			ch.x_position += ch.move_dir * ch.move_speed;
			
			if (ch.x_position > limit) {
				ch.x_position = limit;
				ch.move_dir = -1;
			}
			
			if (ch.x_position < limit) {
				ch.x_position = -limit;
				ch.move_dir = 1;
			}
		}
		


	}
		
	function spawn_egg(_x, _y, _type) {
		
		var data = egg_data[_type]
		
		var egg = {
			x: _x,
			y: _y,
			type: _type,
			speed: data.fall_speed,
			sprite_frame: data.spr_index
		};
		
		array_push(eggs, egg);
	}
	
	

}