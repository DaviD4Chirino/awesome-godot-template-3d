extends Node
const loading_screen_packed: PackedScene = preload("res://scenes/screens/loading_screen.tscn")

var transition_type
## THe instantiated loading, its null if it not loading
var loading_screen: LoadingScreen

var started_processing: bool = false
var loading_scene: bool = false
var scene_path: String
var progress: Array[float] = [0.0]
var scene_load_status: int


func change_scene(
	_scene_path: String,
	_transition_type: LoadingScreen.TransitionTypes = LoadingScreen.TransitionTypes.NONE
) -> void:
	# Prevent double loading, since we are working with await, we used a second flag
	# to prevent the spam of the first half of the function
	if loading_scene or started_processing:
		return
	started_processing = true
	# we pass the variables to a global scope so it can be used in the
	# loading screen and in the process
	scene_path = _scene_path
	transition_type = _transition_type
	#if theres no transition, we skip adding the loading screen
	if _transition_type != LoadingScreen.TransitionTypes.NONE:
		loading_screen = loading_screen_packed.instantiate()
		loading_screen.transition_type = _transition_type

		# Add the loading screen and wait for it to be ready
		get_tree().root.call_deferred("add_child", loading_screen)
		await loading_screen.ready
		#Start transition and wait for it to hit the midpoint, if you want a transition
		loading_screen.start_transition()
		await loading_screen.transition_midpoint

	#Start loading the scene
	ResourceLoader.load_threaded_request(_scene_path)

	loading_scene = true


func _process(_delta):
	if !loading_scene:
		return
	# get the current status of the loading scene
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)

	# when its loaded, we change the scene and end the transition
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene: Resource = ResourceLoader.load_threaded_get(scene_path)
		get_tree().change_scene_to_packed(scene)

		# if theres a transition, we end it
		if transition_type != LoadingScreen.TransitionTypes.NONE:
			loading_screen.end_transition()

		loading_scene = false
		started_processing = false
