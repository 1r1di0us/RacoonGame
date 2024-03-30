extends Node

signal player_died
signal level_complete
signal player_landed
signal player_jumped
signal player_tuck
signal player_roll
signal player_highjump
signal game_paused
signal game_resumed
signal scene_changed

var hover_sound: AudioStreamPlayer
var select_sound: AudioStreamPlayer
var select_sound_next: AudioStreamPlayer
var death_sound: AudioStreamPlayer
var levelcomplete_sound: AudioStreamPlayer
var jumplanding_sound: AudioStreamPlayer
var jump_sound: AudioStreamPlayer
var pause_sound: AudioStreamPlayer
var resume_sound: AudioStreamPlayer
var OnStartMenu = true

func _ready():
	hover_sound = $HoverSound
	select_sound = $SelectSound
	select_sound_next = $SelectSoundNext
	death_sound = $DeathSound
	levelcomplete_sound = $LevelComplete
	jumplanding_sound = $JumpLandingSound
	jump_sound = $JumpSound
	pause_sound = $PauseSound
	resume_sound = $ResumeSound
	
	player_died.connect(on_player_died)
	level_complete.connect(on_level_complete)
	player_landed.connect(on_player_landed)
	player_jumped.connect(on_player_jumped)
	player_tuck.connect(on_player_tuck)
	player_roll.connect(on_player_roll)
	player_highjump.connect(on_player_highjump)
	game_paused.connect(on_game_paused)
	game_resumed.connect(on_game_resumed)
	scene_changed.connect(on_scene_changed)

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(PlayHover)
		
		if get_tree().get_current_scene().get_name() == "LevelOneCutscene":
			node.pressed.connect(PlayPressed)
		elif node.name == "ResumeButton":
			pass
		else:
			node.pressed.connect(PlayPressed)

# Function to smoothly transition between two songs
func transition_songs(current_song: AudioStreamPlayer, next_song: AudioStreamPlayer, transition_time: float):
	var timer = 0.0
	
	while timer < transition_time:
		# Calculate fade values
		var current_volume = 1.0 - timer / transition_time
		var next_volume = timer / transition_time
		
		# Apply volume changes to both songs
		current_song.volume_db = current_volume * -80
		next_song.volume_db = next_volume * -80
		
		# Wait for a short time before the next iteration
		await get_tree().create_timer(0.1).timeout
		
		# Update timer
		timer += 0.1
		
	# Stop the current song and start the next one
	current_song.stop()
	next_song.play()

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

func on_player_roll():
	print()

func on_player_highjump():
	print()

func on_game_paused():
	pause_sound.play()

func on_game_resumed():
	resume_sound.play()

func on_scene_changed(scene_path):
	if (scene_path == "res://ui/level_select_screen.tscn" or scene_path == "res://ui/start_screen.tscn") and OnStartMenu == false:
		OnStartMenu = true
		#Change music to main menu music
		return
	elif (scene_path == "res://ui/level_select_screen.tscn" or scene_path == "res://ui/start_screen.tscn") and OnStartMenu == true:
		#Do nothing
		return
	print(scene_path)
	OnStartMenu = false

func PlayHover() -> void:
	hover_sound.play()

func PlayPressed() -> void:
	select_sound.play()

func PlayPressed2() -> void:
	select_sound_next.play()

