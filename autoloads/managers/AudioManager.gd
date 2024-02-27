extends Node
enum Buses {MASTER, MUSIC, SFX, UI}

var current_music: CustomAudioStreamPlayer = null

func play_music(audio: AudioStream,
	_cross_fade: float=2.0,
	duration: float=0.0,
	delay: float=0.0,
	fade_in: float=0.0,
	fade_out: float=0.0
):
	var old_music: CustomAudioStreamPlayer = current_music
	current_music = create_stream_player(
		audio, duration,
		delay, fade_in,
		fade_out, Buses.MUSIC
	)

	current_music.play()

	if _cross_fade > 0 and old_music:
		cross_fade(old_music, current_music)
		
	else:
		current_music.play()
		if old_music:
			old_music.queue_free()

func play_sound(
	audio: AudioStream,
	duration: float=0.0,
	delay: float=0.0,
	fade_in: float=0.0,
	fade_out: float=0.0,
	## You can use Int if you want
	bus: Buses=Buses.SFX
):
	var new_player: CustomAudioStreamPlayer = create_stream_player(
		audio, duration, delay,
		fade_in, fade_out, bus
	)

	new_player.play()

func create_stream_player(
	audio: AudioStream,
	duration: float=0.0,
	delay: float=0.0,
	fade_in: float=0.0,
	fade_out: float=0.0,
	bus: Buses=Buses.SFX
) -> CustomAudioStreamPlayer:

	var already_playing: CustomAudioStreamPlayer = _find_stream(audio)

	if already_playing:
		already_playing.queue_free()

	# create the player
	var new_player: CustomAudioStreamPlayer = CustomAudioStreamPlayer.new()
	# pass down all the properties
	new_player.stream = audio
	new_player.duration = duration
	new_player.delay = delay
	new_player.fade_in = fade_in
	new_player.fade_out = fade_out
	new_player.bus = AudioServer.get_bus_name(bus)

	add_child(new_player)
	#return the added child
	return new_player

## Gets the volume in decibels
func get_volume_db(bus: Buses) -> float:
	return AudioServer.get_bus_volume_db(bus)

## Gets the volume in a value between 0 and 1
func get_volume(bus: Buses) -> float:
	return ((get_volume_db(bus) - (-80))) / (0 - (-80))

func change_volume(bus: Buses, volume: float):
	AudioServer.set_bus_volume_db(bus, volume)

func remove_stream(stream: AudioStream):
	var existing_stream: CustomAudioStreamPlayer = _find_stream(stream)
	if existing_stream:
		existing_stream.finished.emit()

## Returns the first child playing in the bus
func _find_stream_by_bus(bus: Buses) -> CustomAudioStreamPlayer:
	for child in get_children():
		if child.bus == AudioServer.get_bus_name(bus) and child.is_playing():
			if is_instance_valid(child):
				return child
	return null

## it get the stream and returns the player if it exists
func _find_stream(stream: AudioStream) -> CustomAudioStreamPlayer:
	for child in get_children():
		if child.stream == stream:
			return child
	return null

func _clear_bus(bus: Buses):
	for child in get_children():
		if child.bus == AudioServer.get_bus_name(bus):
			child.queue_free()

func cross_fade(from: CustomAudioStreamPlayer, to: CustomAudioStreamPlayer, time: float=2.0):
	var tween: Tween = create_tween()
	print(from, to)

	tween.parallel().tween_property(
		from, "volume_db", -80, time
	)
	tween.parallel().tween_property(
		to, "volume_db", get_volume_db(Buses.MUSIC), time
	).from( - 80)

	tween.tween_callback(from.queue_free)
