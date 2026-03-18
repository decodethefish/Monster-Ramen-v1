
function draw_meat_row(_x_center, _y, _meats, _spacing) {

    var count = array_length(_meats);
    if (count == 0) return;

    var sprite_w = sprite_get_width(spr_mt_meats);

    var total_width = count * sprite_w + (count - 1) * _spacing;
    var start_x = _x_center - total_width / 2 + sprite_w * 0.5;

    for (var i = 0; i < count; i++) {

        var meat_id = _meats[i];

        var frame = meat_id - 1;
        var mtx = start_x + i * (sprite_w + _spacing);

        draw_sprite(spr_mt_meats, frame, mtx, _y);
    }
}
	