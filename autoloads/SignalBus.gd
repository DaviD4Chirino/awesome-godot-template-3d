extends Node
##Put all your signals here


func _ready():
	process_mode = PROCESS_MODE_ALWAYS


## Engine State Signals
signal game_paused
signal game_resumed
signal game_restarted
signal level_restarted
##


##use this to check if the signal was emitted
func test_signal():
	print("test signal")
