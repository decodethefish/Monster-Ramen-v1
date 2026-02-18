move_x = 0;
move_y = 0;

if (!instance_exists(obj_game)) {
	exit;
}

if (obj_game.game_mode != GAME_MODE.WORLD) {
	exit;
}

if (keyboard_check(ord("A"))) move_x += -1;
if (keyboard_check(ord("D"))) move_x -= -1;
if (keyboard_check(ord("W"))) move_y += -1;
if (keyboard_check(ord("S"))) move_y -= -1;

if (move_x != 0 || move_y != 0) {
	var dir = point_direction(0, 0, move_x, move_y);
	x += lengthdir_x(ply_spd, dir);
	y += lengthdir_y(ply_spd, dir);
}
	
