extends HBoxContainer

@export var option_button: OptionButton
enum {WINDOWED, FULLSCREEN, BORDERLESS_WINDOWED, BORDERLESS_FULLSCREEN}

@onready var selected_mode: int = 0:
	set(index):
		var old_mode = selected_mode
		if index != old_mode:
			selected_mode = index
			change_screen_mode(index)
			save_screen_mode(DisplayServer.window_get_mode())
			option_button.select(get_screen_mode())

func _ready():
	create_options()

func create_options() -> void:
	option_button.add_item("Window", WINDOWED)
	option_button.add_item("Fullscreen", FULLSCREEN)
	option_button.add_item("Borderless Window", BORDERLESS_WINDOWED)
	option_button.add_item("Borderless Fullscreen", BORDERLESS_FULLSCREEN)

	# var current_item_index: int = option_button.get_item_index(DisplayServer.window_get_mode())
	option_button.select(get_screen_mode())

func change_screen_mode(mode: int) -> void:
	match mode:
		WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		BORDERLESS_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		BORDERLESS_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func get_screen_mode() -> int:
	var mode: int = DisplayServer.window_get_mode()

	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS):
			return BORDERLESS_FULLSCREEN
		else:
			return FULLSCREEN
	elif mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		return FULLSCREEN
	else:
		if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS):
			return BORDERLESS_WINDOWED
		else:
			return WINDOWED

func _on_option_button_item_selected(index: int):
	self.selected_mode = index

func save_screen_mode(mode: int) -> void:
	SaveSystem.set_var(SavePaths.video_settings, mode)
	SaveSystem.save()

func _restore_config() -> void:
	self.selected_mode = DisplayServer.WINDOW_MODE_WINDOWED
