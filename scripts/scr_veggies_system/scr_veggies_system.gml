function VeggiesSystem() constructor {
	
	is_passive = false;
	my_station = STATION.NOODLES;

	function init() {
		
	}
	
	function update() {
		
	}
	
	function should_update(_current_station) {
		return is_passive || _current_station == my_station;	
	}
	
}