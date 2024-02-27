extends Node

func _ready():
	load_video_settings()
	load_custom_inputs()
	load_audio_levels()

func load_custom_inputs():
	var custom_input_map = SaveSystem.get_var(SavePaths.input_map)

	## We check if there is any custom input map
	#if there is, we replace our default keys
	if !custom_input_map:
		return

	for action in custom_input_map.keys():
		## if for some reason theres no action with the same name, we skip it
		if !InputMap.has_action(action):
			push_error("Action " + action + " not found in InputMap")
			continue
		var custom_event: InputEvent = (
			SaveSystem
			._dict_to_resource(
				custom_input_map[action],
				# class is a key i manually added to make the conversion easier
				InputActionData.get_input_class(custom_input_map[action]["class"])
			)
		)

		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, custom_event)

func load_audio_levels():
	var audio_levels = SaveSystem.get_var(SavePaths.audio_settings)

	if !audio_levels:
		return

	for audio_level in audio_levels:
		AudioManager.change_volume(audio_level, audio_levels[audio_level])

func load_video_settings():
	var screen_mode: int = SaveSystem.get_var(SavePaths.video_settings, 0)

	if screen_mode:
		DisplayServer.window_set_mode(screen_mode)
