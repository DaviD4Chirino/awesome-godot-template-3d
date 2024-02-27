@tool
extends VBoxContainer
@export var audio_bus_name: AudioManager.Buses = AudioManager.Buses.MASTER:
	set(value):
		audio_bus_name = value
		if !audio_bus_name_label:
			return
		audio_bus_name_label.text = AudioServer.get_bus_name(audio_bus_name).capitalize() + ": "

@export_group("Nodes")
@export var audio_bus_name_label: Label
@export var volume_percentage_label: Label
@export var volume_slider: HSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		return
	audio_bus_name_label.text = AudioServer.get_bus_name(audio_bus_name).capitalize() + ": "
	_update()

func _update():
	volume_slider.value = AudioServer.get_bus_volume_db(audio_bus_name)
	volume_percentage_label.text = str(
		ceil(Utility.get_percentage(
			volume_slider.value,
			volume_slider.min_value,
			volume_slider.max_value
		) * 100),
		"%"
	)

func _on_volume_control_value_changed(value: float):
	AudioManager.change_volume(audio_bus_name, value)
	# Done this way to get the percentage of the slider, not of the volume
	volume_percentage_label.text = str(
		ceil(Utility.get_percentage(
			value,
			volume_slider.min_value,
			volume_slider.max_value
		) * 100),
		"%"
	)
	# ((input - min) * 100) / (max - min)
	pass # Replace with function body.
