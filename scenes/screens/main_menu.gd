extends Control

@export var configuration_screen: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_start_button_pressed():
	SceneManager.change_scene(Scenes.levels.one)

func _on_options_button_pressed():
	configuration_screen.show()

func _on_credits_button_pressed():
	pass # Replace with function body.

func _on_exit_button_pressed():
	Utility.quit_game()
