extends Node

var hover_sound: AudioStreamPlayer
var select_sound: AudioStreamPlayer
var select_sound_next: AudioStreamPlayer

func _enter_tree() -> void:
	hover_sound = $HoverSound
	select_sound = $SelectSound
	select_sound_next = $SelectSoundNext
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(PlayHover)
		
		if get_tree().get_current_scene().get_name() == "LevelOneCutscene":
			node.pressed.connect(PlayPressed2)
		else:
			node.pressed.connect(PlayPressed)


func PlayHover() -> void:
	hover_sound.play()

func PlayPressed() -> void:
	select_sound.play()

func PlayPressed2() -> void:
	select_sound_next.play()
