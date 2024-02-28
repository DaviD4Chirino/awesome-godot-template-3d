extends CanvasLayer
@export var options_screen: CanvasLayer

func _on_options_button_pressed():
	if !options_screen:
		push_error("Options screen not found")
		return

	options_screen.show()

func _on_main_menu_button_pressed():
	var consent_screen: CanvasLayer = Utility.create_consent_screen(
		"Are you sure you want to return to the main menu?"
	)
	consent_screen.accepted.connect(_return_to_main_menu)

func _on_quit_button_pressed():
	var consent_screen: CanvasLayer = Utility.create_consent_screen("Quit the game?")
	consent_screen.accepted.connect(Utility.quit_game)

func _return_to_main_menu() -> void:
	print_debug("returning to main menu")
	SceneManager.change_scene(Scenes.main_menu)

func _on_resume_pressed():
	self.hide()
	Level.resume()
