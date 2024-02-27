@tool
## A resource that takes a signal and a stream and connects it to an audio bus
class_name AudioStreamData extends Resource
enum SignalTypes {
	#Buttons
	pressed,
	#CheckButtons
	toggled,
	#Sliders
	drag_started,
	drag_ended,
	value_changed,
	#ScrollBars
	scrolling,
	scroll_ended,
	scroll_started,
	#TabContainer
	active_tab_rearranged,
	pre_popup_pressed,
	tab_button_pressed,
	tab_changed,
	tab_clicked,
	tab_hovered,
	tab_selected,
	#General
	mouse_entered,
	mouse_exited,
	focus_entered,
	focus_exited,
}

@export var signal_to_connect: SignalTypes
@export var stream: AudioStream
@export var bus: AudioManager.Buses = AudioManager.Buses.SFX
## Where the stream will play
@export_group("Configurations")
## If you want the audio to last only so much
## [b]NOTE:[/b] If you have fades set, the audio will play for longer
@export var duration: float = 0.0
## In seconds
@export var delay: float = 0.0
## In seconds
@export var fade_in: float = 0.0
## In seconds
@export var fade_out: float = 0.0

func _init():
	pass

func on_signal_triggered():
	if bus == AudioManager.Buses.MUSIC:
		AudioManager.play_music(stream, true, duration, delay, fade_in, fade_out)
		return
	AudioManager.play_sound(stream, duration, delay, fade_in, fade_out, bus)
	pass

func get_signal_name() -> StringName:
	return SignalTypes.keys()[signal_to_connect]
