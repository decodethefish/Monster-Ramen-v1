var _spr;

switch (dir) {
    case 0:   case 360: _spr = spr_ply_idle_right; break;
    case 45:            _spr = spr_ply_idle_upright; break;
    case 90:            _spr = spr_ply_idle_up; break;
    case 135:           _spr = spr_ply_idle_upleft; break;
    case 180:           _spr = spr_ply_idle_left; break;
    case 225:           _spr = spr_ply_idle_downleft; break;
    case 270:           _spr = spr_ply_idle_down; break;
    case 315:           _spr = spr_ply_idle_downright; break;
    default:            _spr = spr_ply_idle_down; break;
}

if (anim_index >= sprite_get_number(_spr)) {
    anim_index = 0;
}

draw_sprite_ext(
    _spr,
    floor(anim_index),
    x,
    y,
    0.1,
    0.1,
    0,
    c_white,
    1
);