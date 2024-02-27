## A custom StreamPlayer that handles fade-in-out and duration by itself
extends AudioStreamPlayer
class_name CustomAudioStreamPlayer
## If you want the audio to last only so much
## [b]NOTE:[/b] If you have fades set, the audio will play for longer
@export var duration: float = 0.0
## In seconds
@export var delay: float = 0.0
## In seconds
@export var fade_in: float = 0.0
## In seconds
@export var fade_out: float = 0.0

var cross_fading: bool = false

func _init():
	finished.connect(_on_self_finished)

func _ready():
	if fade_in > 0 and not cross_fading:
		await handle_fade_in()
	if duration > 0:
		handle_duration()

func handle_duration():
	await get_tree().create_timer(duration, true).timeout
	finished.emit()

func handle_fade_in():
	var tween: Tween = create_tween()
	var current_volume_db = AudioManager.get_volume_db(AudioServer.get_bus_index(bus))
	print(current_volume_db)
	tween.tween_property(self, "volume_db", current_volume_db, fade_in).from( - 80)

	await tween.finished

func handle_fade_out():
	var tween: Tween = create_tween()
	tween.tween_property(self, "volume_db", -80, fade_out)
	await tween.finished

func _on_self_finished():
	# if it is cross-fading, the queue free will be handled by AudioManager
	if cross_fading:
		return
	if fade_out:
		await handle_fade_out()
	queue_free()