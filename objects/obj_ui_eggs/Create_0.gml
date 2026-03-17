// Clear button
cl_button_w = sprite_get_width(spr_egg_clear_button);
cl_button_h = sprite_get_height(spr_egg_clear_button);

cl_button_x = display_get_gui_width() - cl_button_w * 0.5;
cl_button_y = display_get_gui_height() - cl_button_h * 0.5;

// Serve button
srv_button_w = sprite_get_width(spr_egg_serve_button);
srv_button_h = sprite_get_height(spr_egg_serve_button);

srv_button_x = srv_button_w * 0.5;
srv_button_y = display_get_gui_height() - srv_button_h * 0.5;

// Mesa
table_h = sprite_get_height(spr_egg_table);

table_x = display_get_gui_width() * 0.5;
table_y = display_get_gui_height() - table_h * 0.5;

// Serving layout
serving_egg_spacing = 60;
serving_egg_scale = 2;
serving_egg_y = table_y + 25;

// Bowls
bowls = [];

var bowl_spacing = 120;
var bowl_start_x = table_x - bowl_spacing;
var bowl_y = table_y - 60;

for (var i = 0; i < 3; i++) {
    var bx = bowl_start_x + i * bowl_spacing;
    var by = bowl_y;

    var bw = instance_create_layer(bx, by, "UI", obj_bowl_ui);

    bowls[i] = bw;

    bw.x_start = bx;
    bw.y_start = by;
    bw.bowl_index = i;
}
block_bowl_move = true;

// Huevos
dragging_egg = false;
drag_egg_index = -1;
drag_egg_type = -1;
drag_egg_frame = -1;
egg_c_w = sprite_get_width(spr_egg) * serving_egg_scale;
egg_c_h = sprite_get_height(spr_egg) * serving_egg_scale;