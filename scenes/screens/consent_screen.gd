extends CanvasLayer
@export var message_label: Label

@export var message: String = "Are you sure?"

signal accepted
signal declined


func _ready():
	message_label.text = message


func _on_confirm_pressed():
	accepted.emit()
	queue_free()


func _on_cancel_pressed():
	declined.emit()
	queue_free()
