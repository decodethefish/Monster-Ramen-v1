half_w = display_get_gui_width() * 0.5;
half_h = display_get_gui_height() * 0.5;

tray_h = sprite_get_height(spr_review_tray);
tray_x = display_get_gui_width() * 0.5;
tray_y = display_get_gui_height() - tray_h * 0.5;

customer_x = half_w;
customer_y = display_get_gui_height() - tray_h;

// bowls
bowls = [];

var bowl_spacing = 120;
var bowl_start_x = tray_x - bowl_spacing;
var bowl_y = tray_y - 10;

for (var i = 0; i < 3; i++) {
    var bx = bowl_start_x + i * bowl_spacing;
    var by = bowl_y;

    var bw = instance_create_layer(bx, by, "UI", obj_bowl_ui);

    bowls[i] = bw;

    bw.x_start = bx;
    bw.y_start = by;
    bw.bowl_index = i;
}
