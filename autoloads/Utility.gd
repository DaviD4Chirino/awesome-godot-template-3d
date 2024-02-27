extends Node

func create_consent_screen(message: String="Are you sure?") -> CanvasLayer:
	var consent_screen = preload ("res://scenes/screens/consent_screen.tscn").instantiate()
	consent_screen.message = message
	get_tree().root.add_child(consent_screen)
	return consent_screen

## Returns a value between 0 and 1
func get_percentage(value: float, min_value: float, max_value: float) -> float:
	return ((value - min_value)) / (max_value - min_value)

func set_inputs(dict: Dictionary):
	var dict_actions: Array = dict.keys()
	var dict_events: Array = dict.values()

	for i in dict_actions.size():
		var _name: StringName = dict_actions[i]

		if !InputMap.has_action(_name):
			continue

		var _event = dict_events[i]

func connect_signal(
	signal_name: StringName, node_with_signals: Node, function_to_bind: Callable
) -> void:
	if !node_with_signals.has_signal(signal_name):
		push_error("Signal " + str(signal_name) + " doesn't exist!")
		return
	var signal_data = _get_signal_data(signal_name, node_with_signals)
	if signal_data.args.size() == 0:
		node_with_signals.connect(signal_name, function_to_bind)
	else:
		node_with_signals.connect(signal_name, function_to_bind.unbind(signal_data.args.size()))

## its only objective is to return a signal dictionary, most importantly for this example, the size of the arguments
func _get_signal_data(signal_name: StringName, node_with_signals: Node) -> Dictionary:
	var signal_list = node_with_signals.get_signal_list()
	for _signal in signal_list:
		if _signal.name == signal_name:
			return _signal

	return {
		"name": "",
		"args": [],
	}

## This way it can trigger signals and others
func quit_game() -> void:
	get_tree().quit()

func pause_game():
	SignalBus.game_paused.emit()
	get_tree().paused = true

func resume_game():
	SignalBus.game_resumed.emit()
	get_tree().paused = false

func restart_level():
	SignalBus.level_restarted.emit()
	get_tree().reload_current_scene()

func restart_game():
	SignalBus.game_restarted.emit()
	SceneManager.change_scene(Scenes.main_menu)
