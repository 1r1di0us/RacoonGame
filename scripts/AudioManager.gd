extends Node

signal player_died
signal level_complete
signal player_landed
signal player_jumped
signal player_tuck

var hover_sound: AudioStreamPlayer
var select_sound: AudioStreamPlayer
var select_sound_next: AudioStreamPlayer
var death_sound: AudioStreamPlayer
var levelcomplete_sound: AudioStreamPlayer
var jumplanding_sound: AudioStreamPlayer
var jump_sound: AudioStreamPlayer

func _ready():
	hover_sound = $HoverSound
	select_sound = $SelectSound
	select_sound_next = $SelectSoundNext
	death_sound = $DeathSound
	levelcomplete_sound = $LevelComplete
	jumplanding_sound = $JumpLandingSound
	jump_sound = $JumpSound
	
	player_died.connect(on_player_died)
	level_complete.connect(on_level_complete)
	player_landed.connect(on_player_landed)
	player_jumped.connect(on_player_jumped)
	player_tuck.connect(on_player_tuck)

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(PlayHover)
		
		if get_tree().get_current_scene().get_name() == "LevelOneCutscene":
			node.pressed.connect(PlayPressed)
		else:
			node.pressed.connect(PlayPressed)

func on_player_died():
	death_sound.play()

func on_level_complete():
	levelcomplete_sound.play()

func on_player_landed():
	jumplanding_sound.play()

func on_player_jumped():
	jump_sound.play()

func on_player_tuck():
	jump_sound.play()

func PlayHover() -> void:
	hover_sound.play()

func PlayPressed() -> void:
	select_sound.play()

func PlayPressed2() -> void:
	select_sound_next.play()
