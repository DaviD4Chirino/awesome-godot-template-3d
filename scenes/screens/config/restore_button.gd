extends CustomButton
## This button takes a list of nodes and call their _restore_config
## function when pressed. They are responsible to restore their config as needed
@export var restore_nodes: Array[Node]


func _init():
	pressed.connect(_on_pressed)


func _on_pressed():
	if !restore_nodes or restore_nodes.size() == 0:
		push_warning("No config node to restore")
		return

	## if the consent screen is denied, nothing happens, if it's accepted, the config is restored
	var consent_screen = Utility.create_consent_screen()
	consent_screen.accepted.connect(restore)


func restore() -> void:
	for node in restore_nodes:
		# check if the node has a _restore_config function
		if !node.has_method("_restore_config"):
			push_warning("Config Node " + node.name + " doesn't have a _restore_config function! ")
			continue

		node._restore_config()
