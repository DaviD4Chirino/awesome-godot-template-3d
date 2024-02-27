extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.volume_slider.drag_ended.connect(save_audio_levels.unbind(1))

func save_audio_levels():
	var dict = {}
	for bus in AudioManager.Buses.values():
		dict[bus] = AudioServer.get_bus_volume_db(bus)

	SaveSystem.set_var(SavePaths.audio_settings, dict)
	SaveSystem.save()

func _restore_config():
	for bus in AudioManager.Buses.values():
		AudioManager.change_volume(bus, 0.0)

	for child in get_children():
		child._update()
	save_audio_levels()
