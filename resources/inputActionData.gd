@tool
extends Resource
class_name InputActionData

##it has to be present in the project settings
@export var action_name: StringName = "":
	set = set_action_name

## The name to be displayed
@export var action_title: StringName

var input_type: String


static func get_input_class(type: String) -> InputEvent:
	match type:
		"InputEventKey":
			return InputEventKey.new()
		"InputEventMouseButton":
			return InputEventMouseButton.new()
		"InputEventMouseMotion":
			return InputEventMouseMotion.new()
		"InputEventJoypadMotion":
			return InputEventJoypadMotion.new()
		"InputEventJoypadButton":
			return InputEventJoypadButton.new()
		"InputEventScreenTouch":
			return InputEventScreenTouch.new()
		"InputEventScreenDrag":
			return InputEventScreenDrag.new()
		"InputEventMagnifyGesture":
			return InputEventMagnifyGesture.new()
		"InputEventPanGesture":
			return InputEventPanGesture.new()
		"InputEventMIDI":
			return InputEventMIDI.new()
		"InputEventShortcut":
			return InputEventShortcut.new()
		"InputEventAction", _:
			return InputEventAction.new()


func set_action_name(new_action_name: String) -> void:
	action_name = new_action_name
	resource_name = action_name
