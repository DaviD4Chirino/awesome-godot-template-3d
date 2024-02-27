extends VBoxContainer
## The list of action that are allowed to be remapped
@export var input_actions: InputActionDictionary

const input_button_scene: PackedScene = preload ("res://scenes/screens/config/input_button.tscn")

var is_remapping: bool
var action_to_remap: InputActionData
var remapping_button: InputButton

func _ready():
	create_action_list()

func create_action_list() -> void:
	#we delete all the children of the action list if theres any
	if get_children().size() > 0:
		for action in get_children():
			action.queue_free()

	#we add all the actions
	#in this case we get the action list from the custom resource
	for input in input_actions.list:
		var button: InputButton = input_button_scene.instantiate()
		if !InputMap.has_action(input.action_name):
			printerr("Action " + input.action_name + " not found in InputMap")
			continue

		button.input_action = input
		# we need to make the saving here because we need the whole list
		button.input_action_changed.connect(save_custom_inputs)

		add_child(button)

func update_action_list(button: InputButton, event: InputEvent) -> void:
	button.label_input.text = event.as_text().trim_suffix(" (Physical)")

func _restore_config():
	InputMap.load_from_project_settings()
	create_action_list()
	save_custom_inputs()

func save_custom_inputs() -> void:
	# we transform the list into a readable dictionary
	var map: Dictionary = {}
	for action in input_actions.list:
		if !InputMap.has_action(action.action_name):
			continue
		var _event: InputEvent = InputMap.action_get_events(action.action_name)[0]
		map[action.action_name] = SaveSystem._resource_to_dict(_event)
		# We need to add the class type to the dictionary, so later SaveSystem can convert it back into the appropriate InputEvent resource
		map[action.action_name]["class"] = action.input_type

	SaveSystem.set_var(SavePaths.input_map, map)
	SaveSystem.save()
