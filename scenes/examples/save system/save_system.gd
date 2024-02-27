extends Control

@export var counters: Array[VBoxContainer]


func _ready():
	load_counters()


func _on_save_button_pressed():
	save_counters()
	pass  # Replace with function body.


func _on_load_button_pressed():
	load_counters()
	pass  # Replace with function body.


func save_counters():
	if counters.size() == 0:
		return

	for counter in counters:
		var count: int = counter.count
		var counter_name: StringName = str("counter_%d" % counters.find(counter))
		SaveSystem.set_var(counter_name, count)

	SaveSystem.save()


func load_counters():
	if counters.size() == 0:
		return

	for counter in counters:
		var counter_name: StringName = str("counter_%d" % counters.find(counter))
		var count: int = SaveSystem.get_var(counter_name, 0)
		counter.count = count

	pass
