interaction = noone;

half_w = display_get_gui_width() * 0.5;
half_h = display_get_gui_height() * 0.5;

table_h = sprite_get_height(spr_order_table);
table_half = sprite_get_height(spr_order_table) * 0.5;

ticket_bar_x = sprite_get_width(spr_tk_board) * 0.5;
ticket_bar_y = half_h;

order_generated = false;
