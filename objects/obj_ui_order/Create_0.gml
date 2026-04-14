customer = obj_game.current_customer;

// anchors
half_w = display_get_gui_width() * 0.5;
half_h = display_get_gui_height() * 0.5;

dialog_lines = [
	
	"¡Vaya, a ti no te conozco!",
	"¿Cómo te llamas, colega?",
	"¡Un placer conocerte, cocinitas! ¡Estoy hambriento! Ponme uno de esos riquísimos tazones con cosas dentro."
];

dialog_index = 0;
dialog_done = false;