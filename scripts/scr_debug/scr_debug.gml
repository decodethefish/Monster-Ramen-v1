function meat_to_string(_id) {
    switch (_id) {
        case MEAT_ID.NONE: return "NONE";
        case MEAT_ID.BEEF: return "BEEF";
        case MEAT_ID.BUG: return "BUG";
        case MEAT_ID.DRAGON: return "DRAGON";
    }
    return "UNKNOWN";
}

function broth_to_string(_id) {
    switch (_id) {
        case BROTH_ID.NONE: return "NONE";
        case BROTH_ID.CHICKEN: return "CHICKEN";
        case BROTH_ID.ROTTEN: return "ROTTEN";
    }
    return "UNKNOWN";
}

function noodle_to_string(_id) {
    switch (_id) {
        case NOODLE_ID.NONE: return "NONE";
        case NOODLE_ID.WHEAT: return "WHEAT";
        case NOODLE_ID.BONE: return "BONE";
        case NOODLE_ID.STONE: return "STONE";
        case NOODLE_ID.CURSED: return "CURSED";
    }
    return "UNKNOWN";
}

function egg_to_string(_id) {
    switch (_id) {
        case EGG_TYPE.NORMAL: return "NORMAL";
        case EGG_TYPE.ROTTEN: return "ROTTEN";
        case EGG_TYPE.FIRE: return "FIRE";
        case EGG_TYPE.SHADOW: return "SHADOW";
        case EGG_TYPE.WATER: return "WATER";
        case EGG_TYPE.GOLD: return "GOLD";
    }
    return "UNKNOWN";
}

function veggie_to_string(_id) {
    switch (_id) {
        case VEGGIE_TYPE.CARROT: return "CARROT";
        case VEGGIE_TYPE.MUSHROOM: return "MUSHROOM";
        case VEGGIE_TYPE.BOK_CHOY: return "BOK_CHOY";
    }
    return "UNKNOWN";
}

function veggie_result_to_string(_id) {
    switch (_id) {
        case VEGGIE_RESULT.BLEEDING: return "BLEEDING";
        case VEGGIE_RESULT.SPECTRAL: return "SPECTRAL";
        case VEGGIE_RESULT.MAGICAL: return "MAGICAL";

        case VEGGIE_RESULT.CURSED: return "CURSED";
        case VEGGIE_RESULT.CORRUPT: return "CORRUPT";
        case VEGGIE_RESULT.DARK: return "DARK";

        case VEGGIE_RESULT.ALCHEMICAL: return "ALCHEMICAL";
        case VEGGIE_RESULT.PARADOX: return "PARADOX";
        case VEGGIE_RESULT.ETERNAL: return "ETERNAL";
    }
    return "UNKNOWN";
}

function tender_to_string(_zone) {
    switch (_zone) {
        case 0: return "RED";
        case 1: return "ORANGE";
        case 2: return "YELLOW";
        case 3: return "GREEN";
        case 4: return "BLUE";
        case 5: return "PURPLE";
    }
    return "UNKNOWN";
}