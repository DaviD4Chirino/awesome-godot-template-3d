extends Node3D
class_name Level
## TODO: Delete the pause functions in utility and write them here
@export var pause_menu: CanvasLayer

static var is_paused: bool = false

func _ready():
	g.playground = self
	
	SignalBus.game_paused.connect(_on_game_paused)
	SignalBus.game_resumed.connect(_on_game_resumed)
	SignalBus.game_restarted.connect(_on_game_resumed)

func _input(event):
	if event.is_action_pressed("ACTION_PAUSE"):
		if is_paused:
			Level.resume()
			return
		Level.pause()

	if event.is_action_pressed("ACTION_START"):
		is_paused = false
		Level.resume()

func _on_game_paused():
	pause_menu.show()

func _on_game_resumed():
	pause_menu.hide()

static func pause() -> void:
	is_paused = true
	Utility.pause_game()

static func resume() -> void:
	is_paused = false
	Utility.resume_game()

static func restart() -> void:
	is_paused = false
	Utility.restart_level()
