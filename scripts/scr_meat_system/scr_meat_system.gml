function MeatSystem() constructor{
	
	my_station = STATION.MEAT;
	
	meats_data = [];
	active_meats = [];

	function init() {
		
		meats_data[MEAT_ID.BEEF] = {
			gravity: 0.25,
			tender_time: 120,
			cook_time: 100
		};
		
		meats_data[MEAT_ID.BUG] = {
			gravity: 0.35,
			tender_time: 100,
			cook_time: 100
		};
		
		meats_data[MEAT_ID.DRAGON] = {
			gravity: -0.2,
			tender_time: 120,
			cook_time: 100
		};
	}
	
	meat_station = {
	
		available_meats: [
			MEAT_ID.BEEF,
			MEAT_ID.BUG,
			MEAT_ID.DRAGON
		],
		
		selector_spacing: 20,
		selector_y: 50,
		
		// carne en tabla
		has_meat: false,
		type: MEAT_ID.NONE,
		state: MEAT_STATE.RAW,
		
	}
}