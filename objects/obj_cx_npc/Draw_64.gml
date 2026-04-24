draw_self();
draw_set_colour(c_black);
var c_active = (obj_game.customers.active_customer == id);

// distancia al target
var dist = point_distance(x, y, target_x, target_y);
var at_target = (dist <= 2);

// texto debug
var txt = 
    "STATE: " + string(state) + "\n" +
    "ACTIVE: " + string(c_active) + "\n" +
    "LOCKED: " + string(locked) + "\n" +
    "HAS_ORDER: " + string(has_order) + "\n" +
    "DIST: " + string_format(dist, 0, 2) + "\n" +
    "AT_TARGET: " + string(at_target) + "\n" +
    "TARGET: (" + string(target_x) + "," + string(target_y) + ")";

// dibujar encima del cliente
draw_set_colour(c_white);
draw_set_font(fnt_debug);
draw_text(x + 20, y - 60, txt);

// línea hacia target
draw_set_colour(c_red);
draw_line(x, y, target_x, target_y);

// punto target
draw_set_colour(c_lime);
draw_circle(target_x, target_y, 4, false);