function EggSystem() constructor {
	
	station_state = EGG_STATION_STATE.CATCHING;
	is_passive = false;
	my_station = STATION.EGGS;
	
	max_chickens = 5;
	active_chickens = 5;
	chickens = [];
	chicken_sprites = [];
	chicken_y = 90;
	
	platform_width = sprite_get_width(spr_egg_platform);
	platform_margin = 10;
	spacing = sprite_get_width(spr_egg_chicken_normal) * 2;
	
	eggs = [];
	egg_data = [];
	caught_eggs = [];
	
	basket_x = 0;
	basket_y = 0;
	
	basket_speed_base = 2;
	basket_speed_min = 1;
	basket_speed_penalty = 0.4;
	
	basket_capacity = 3;
	
	function init () {
		
        chickens = array_create(max_chickens);

        var center_x = display_get_gui_width() * 0.5;
        var group_width = (max_chickens - 1) * spacing;
        var start_x = center_x - group_width * 0.5;
		
		basket_x = center_x;
		basket_y = display_get_gui_height() - 40;

        for (var i = 0; i < max_chickens; i++) {

            chickens[i] = {

                type: i,
                x: start_x + i * spacing,
				y: chicken_y,
				
                move_dir: (i mod 2 == 0) ? 1 : -1,
                move_speed: random_range(0.5, 1),
				
                egg_timer: irandom_range(1, 3),
				
				state: CHICKEN_STATE.WALK,
				state_timer: random_range(0.5, 6)
				

            };
		}

		chicken_sprites[CHICKEN_TYPE.NORMAL] = spr_egg_chicken_normal;
		chicken_sprites[CHICKEN_TYPE.FIRE]   = spr_egg_chicken_fire;
		chicken_sprites[CHICKEN_TYPE.WATER]  = spr_egg_chicken_water;
		chicken_sprites[CHICKEN_TYPE.GOLD]   = spr_egg_chicken_gold;
		chicken_sprites[CHICKEN_TYPE.SHADOW] = spr_egg_chicken_shadow;
		
		egg_data[EGG_TYPE.NORMAL] = {
			fall_speed: 2,
			spr_index: 0
		};
		egg_data[EGG_TYPE.ROTTEN] = {
			fall_speed: 2,
			spr_index: 1
		};
		egg_data[EGG_TYPE.FIRE] = {
			fall_speed: 3,
			spr_index: 2
		};
		egg_data[EGG_TYPE.SHADOW] = {
			fall_speed: 1,
			spr_index: 3		
		};		
		egg_data[EGG_TYPE.WATER] = {
			fall_speed: 4,
			spr_index: 4
		};
		egg_data[EGG_TYPE.GOLD] = {
			fall_speed: 5,
			spr_index: 5
		};
		
		
	}
	
	function should_update(_current_station) {
		return is_passive || _current_station == my_station;	
	}
	
    function update(_dt) {

        var center_x = display_get_gui_width() * 0.5;
        var half = platform_width * 0.5;
		
        var left  = center_x - half + platform_margin;
        var right = center_x + half - platform_margin;

		var ch_half = sprite_get_height(spr_egg_chicken_normal) * 0.5;
		
		// Gallinas
        for (var i = 0; i < active_chickens; i++) {

            var ch = chickens[i];
			ch.state_timer -= _dt;
			
			switch(ch.state) {
				
				
				case CHICKEN_STATE.WALK:
					
					ch.x += ch.move_dir * ch.move_speed;
					
					if (ch.state_timer <= 0) {
						
						ch.state = CHICKEN_STATE.IDLE;
						ch.state_timer = irandom_range(0.5, 2);
						
						if (station_state == EGG_STATION_STATE.CATCHING) {
							var egg_origin = ch.y + ch_half; 
							var egg_type = get_egg_type(ch.type);
							spawn_egg(ch.x, egg_origin, egg_type);
						}
						
					}
					
				break;
				
				
				case CHICKEN_STATE.IDLE:
					if (ch.state_timer <= 0) {
						ch.state = CHICKEN_STATE.WALK;
						ch.move_dir = choose(-1,1);
						ch.state_timer = irandom_range(1, 2);
					}
				
				break;
			}
			

            if (ch.x > right) {
                ch.x = right;
                ch.move_dir = -1;
            }

            if (ch.x < left) {
                ch.x = left;
                ch.move_dir = 1;
            }
		}
			
		// Huevos
		
		for (var i = array_length(eggs) - 1; i >= 0; i--) {
			
			var basket_top = basket_y - 16;
			var catch_zone = basket_top + 8;
			
			var egg = eggs[i];
			egg.y += egg.speed;
			
			// captura
			if (station_state == EGG_STATION_STATE.CATCHING) {
				
				if (egg.y >= basket_top && egg.y <= catch_zone) {
				
					if (egg.x > basket_x - 32 && egg.x < basket_x + 32) {
					
						if (array_length(caught_eggs) < basket_capacity) {
						
							var basket_egg = {
								type: egg.type,
								sprite_frame: egg.sprite_frame
							};
						
							array_push(caught_eggs, basket_egg);
							array_delete(eggs, i, 1);
							continue;
						
						}
					}
				}
			}
	
			// perdidos
			if (egg.y > display_get_gui_height()) {
				array_delete(eggs, i, 1);
			}
		}
			
		// Canasta	
		if (station_state == EGG_STATION_STATE.CATCHING) {
			
			var egg_count = array_length(caught_eggs)
			var basket_speed = basket_speed_base - (egg_count * basket_speed_penalty);
			basket_speed = max(basket_speed_min, basket_speed);
			
			var move = keyboard_check(ord("D")) - keyboard_check(ord("A"));
			basket_x += move * basket_speed;
		
			var basket_half = sprite_get_width(spr_egg_basket) * 0.5;
		
			basket_x = clamp(basket_x, basket_half, display_get_gui_width() - basket_half);
			
		}
		
    }
		
	function get_egg_type(_chicken_type) {
		
		switch (_chicken_type) {
			
			case CHICKEN_TYPE.NORMAL:
				
				if (random(1) < 0.6)
					return EGG_TYPE.NORMAL;
				else
					return EGG_TYPE.ROTTEN;
					
			case CHICKEN_TYPE.FIRE:
				return EGG_TYPE.FIRE;

			case CHICKEN_TYPE.WATER:
				return EGG_TYPE.WATER;

			case CHICKEN_TYPE.GOLD:
				return EGG_TYPE.GOLD;	

			case CHICKEN_TYPE.SHADOW:
				return EGG_TYPE.SHADOW;
				
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