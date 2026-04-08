function scr_enums(){

// game managing
	enum GAME_MODE {
		WORLD,
		COOKING
	}
	enum STATION {
		BROTH,
		NOODLES,
		MEAT,
		EGGS,
		VEGGIES,
	}

// broth system
	enum BROTH_ID {
		NONE,
		CHICKEN,
		ROTTEN
	}
	enum POT_STATE {
		EMPTY,
		COOKING,
		READY,
		BURNED
	}

// noodle system
	enum NOODLE_ID {
		NONE,
		WHEAT,
		MUCUS,
		STONE,
		CURSED
	}
	enum NOODLE_STATE {
		NO_SHEET,
	    ACTIVE,
	    CUTTING,
	    RITUAL_SELECT,
		RITUAL_TRANSFORM,
	    RITUAL_PATTERN,
	    RITUAL_INPUT,
	    RITUAL_FAIL,
	    COMPLETE        
	}
	
// egg system
	enum CHICKEN_TYPE {
		NORMAL,
		FIRE,
		SHADOW,
		WATER,
		GOLD
	}
	enum EGG_TYPE {
		NORMAL,
		ROTTEN,
		FIRE,
		SHADOW,
		WATER,
		GOLD,
	}
	enum CHICKEN_STATE {
		IDLE,
		WALK
	}
	enum EGG_STATION_STATE {
		CATCHING,
		SERVING
	}

// meat system

	enum MEAT_ID {
		NONE,
		BEEF,
		BUG,
		DRAGON
	}
	enum MEAT_STATE {
		RAW,
		TENDER,
		READY_FOR_GRILL,
		GRILL,
		DONE
	}
	enum MEAT_MODE {
		TENDER,
		COOK
	}
	enum COOK_STATE {
		EMPTY,
		COOKING,
		DONE,
		BURNING
	}
		
// veggies system
	
	enum ITEM_KIND {
		VEG,
		GEM,
		RESULT
	}
	enum VEGGIE_TYPE {
		CARROT,
		MUSHROOM,
		BOK_CHOY
	}
	enum GEM_TYPE {
		CRIMSON,
		SOUL,
		ARCANE
	}
	enum VEGGIE_RESULT {
		
		BLEEDING,
		SPECTRAL,
		MAGICAL,
		
		CURSED,
		CORRUPT,		
		DARK,
		
		ALCHEMICAL,
		PARADOX,
		ETERNAL
	}
	enum VEGGIE_TIER {
		T1,
		T2,
		T3,
		T4,
		T5
	}

}