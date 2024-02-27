class_name LoadingScreen extends CanvasLayer

enum TransitionTypes {
	NONE,
	FADE,
}

@export var transition_type: TransitionTypes = TransitionTypes.FADE

@export_category("Nodes")
@export var animation_player: AnimationPlayer
@export var progress_bar: ProgressBar
@export var progress_timer: Timer
@export var transition_screen: ColorRect

##if its true, the timer has triggered which means the scene takes a while to load
# and that means the progress bar should be shown and updated
var tracking_progress: bool = false

signal transition_midpoint
signal transition_complete


func _ready():
	progress_bar.hide()
	transition_complete.connect(on_transition_finished)


func _process(_delta):
	if tracking_progress:
		progress_bar.value = floor(SceneManager.progress[0] * 100)


func start_transition():
	match transition_type:
		TransitionTypes.NONE:
			transition_midpoint.emit()

		TransitionTypes.FADE:
			animation_player.play("fade_out")
			progress_timer.start()
			await animation_player.animation_finished
			transition_midpoint.emit()

		_:
			push_warning("Invalid transition type of: " + TransitionTypes.keys()[transition_type])


func end_transition():
	match transition_type:
		TransitionTypes.NONE:
			transition_complete.emit()

		TransitionTypes.FADE:
			progress_bar.hide()
			animation_player.play("fade_in")
			await animation_player.animation_finished
			transition_complete.emit()
		_:
			push_warning("Invalid transition type of: " + TransitionTypes.keys()[transition_type])


func on_transition_finished():
	queue_free()


func _on_timer_timeout():
	tracking_progress = true
	progress_bar.show()
