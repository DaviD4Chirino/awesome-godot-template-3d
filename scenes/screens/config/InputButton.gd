extends CustomButton
class_name InputButton
@export var input_action: InputActionData = null:
	set = set_input_action

@export_category("Nodes")
@export var label_action: Label
@export var label_input: Label
@export var input_icon: InputIconTextureRect
var is_remapping: bool

signal input_action_changed

func _ready():
	pressed.connect(_on_input_pressed)

func _on_input_pressed():
	if !is_remapping:
		is_remapping = true

		label_input.text = "Press a key to bind..."
	pass

func _input(event):
	if is_remapping:
		if (event is InputEventKey) or (event is InputEventMouseButton and event.is_pressed()):
			#turn off double press
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false

			InputMap.action_erase_events(input_action.action_name)
			InputMap.action_add_event(input_action.action_name, event)

			update_button()

			is_remapping = false

			accept_event()
			input_action_changed.emit()

			# save_custom_inputs()

func update_button() -> void:
	if !input_action or !label_input:
		return

	# We get the events
	var events: Array[InputEvent] = InputMap.action_get_events(input_action.action_name)

	# A check to see if we have that event and we take the first one
	if events.size() > 0:
		var event: InputEvent = events[0]
		var has_icon: bool = InputIcon.get_icon(input_action.action_name, 0) != null
		
		input_action.input_type = event.get_class()
		input_icon.visible = has_icon

		if has_icon:
			input_icon.action_name = input_action.action_name
			label_input.text = ""
		else:
			input_icon.action_name = ""
			label_input.text = event.as_text().trim_suffix(" (Physical)")

func save_custom_inputs():
	var dict: Dictionary = {}
	dict[input_action.action_name] = SaveSystem._resource_to_dict(
		InputMap.action_get_events(input_action.action_name)[0]
	)

func get_custom_inputs() -> Dictionary:
	return SaveSystem.get_var("custom_input_map")

############
# Setters
############
func set_input_action(new_action: InputActionData) -> void:
	if !new_action:
		return
	# we make sure that the inputmap is properly loaded
	input_action = new_action

	if label_action:
		label_action.text = (
			input_action.action_name if not input_action.action_title else input_action.action_title
		)

	update_button()
