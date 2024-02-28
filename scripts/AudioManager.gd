extends Node

var hover_sound: AudioStreamPlayer

func _enter_tree() -> void:
	hover_sound = $HoverSound
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)


func _play_hover() -> void:
	hover_sound.play()


func _play_pressed() -> void:
	hover_sound.play()
