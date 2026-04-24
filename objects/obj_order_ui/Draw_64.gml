if (interaction == noone) exit;

// --------- FONDO ---------
draw_set_colour(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// --------- MESA ---------
draw_sprite(spr_order_table, 0, half_w, display_get_gui_height() - table_half);

// --------- PORTRAIT ---------
var c = interaction.customer;
if (instance_exists(c)) {
    draw_sprite(spr_customer_npc, c.portrait_index_id, half_w, display_get_gui_height() - table_h);
}

// --------- FONDO TICKETS ---------
draw_sprite(spr_tk_board, 0, ticket_bar_x, ticket_bar_y);

// --------- TEXTO ---------
draw_set_font(fnt_default);
draw_set_colour(c_white);
draw_set_halign(fa_center);

var lines = interaction.dialog_lines;
var i = interaction.dialog_index;
if (is_array(lines) && i < array_length(lines)) {
    draw_text(half_w, 300, lines[i]);
}

// --------- TICKETS ---------
var t = obj_game.orders.get_preview_ticket();
if (is_struct(t) && instance_exists(obj_tickets_ui)) {
    with (obj_tickets_ui) {
        draw_ticket_details(t, other.ticket_bar_x, other.ticket_bar_y);
    }
}