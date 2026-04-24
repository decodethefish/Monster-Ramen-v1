var center_x = display_get_gui_width() * 0.5;
var arr = obj_game.orders.get_tickets();
var count = array_length(arr);

// -------- CUERDA --------
draw_set_colour(c_black);
draw_line(0, y_anchor - 20, display_get_gui_width(), y_anchor - 20);

if (count <= 0) exit;

// -------- MINI TICKETS--------
var start_x = center_x - (count - 1) * spacing * 0.5;

for (var i = 0; i < count; i++) {
    var t = arr[i];
    if (!is_struct(t)) continue;

    var tx = start_x + i * spacing;
    var ty = y_anchor;

    t.draw_x = tx;
    t.draw_y = ty;

    draw_sprite(spr_tk_stations, i, tx, ty);
}

// -------- TICKETS ora sí --------
if (hover_index != -1 && hover_index < count) {
    var ticket = arr[hover_index];
    if (is_struct(ticket)) {
        var tx_big = ticket.draw_x;
        var th = sprite_get_height(spr_tk_stations) * 0.5;
        var tbh = sprite_get_height(spr_tk_base) * 0.5;
        var base_y = ticket.draw_y + th + tbh + 10;
        var ty_big = base_y + preview_offset;

        draw_ticket_details(ticket, tx_big, ty_big);
    }
}