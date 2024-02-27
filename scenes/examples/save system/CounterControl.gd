extends VBoxContainer
@export var counter_label: Label

var count: int = 0:
	set(value):
		count = value
		counter_label.text = str(count)


func _ready():
	counter_label.text = str(count)


func _on_plus_counter_button_pressed():
	self.count += 1


func _on_minus_counter_button_pressed():
	self.count -= 1
