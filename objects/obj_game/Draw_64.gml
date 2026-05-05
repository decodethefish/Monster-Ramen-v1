if (game_mode == GAME_MODE.WORLD)	 {
	dock_y = sprite_get_height(spr_dock_base) * 0.5;
	draw_dock_for_station(display_get_gui_width() * 0.5, dock_y);
}