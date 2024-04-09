extends Node

#Initializing signals
signal player_died
signal level_complete
signal player_landed
signal player_jumped
signal player_tuck
signal player_roll
signal player_highjump
signal player_rummaging
signal player_rummagingstop
signal player_itemcollected
signal player_brushpast
signal player_launchready
signal game_paused
signal game_resumed
signal scene_changed
signal footstep_run
signal footstep_crawl
signal footstep_climbingpole
signal footstep_climbingwall
signal splat
signal exit_error
signal PlayerDeadSetFalse

#Initializing sound effect variables
var hover_sound: AudioStreamPlayer
var select_sound: AudioStreamPlayer
var select_sound_next: AudioStreamPlayer
var death_sound: AudioStreamPlayer
var levelcomplete_sound: AudioStreamPlayer
var jumplanding_sound: AudioStreamPlayer
var jump_sound: AudioStreamPlayer
var pause_sound: AudioStreamPlayer
var resume_sound: AudioStreamPlayer
var footsteps: AudioStreamPlayer
var rummaging_sound: AudioStreamPlayer
var itemcollected_sound: AudioStreamPlayer
var bush_sound: AudioStreamPlayer
var climbing_pole: AudioStreamPlayer
var climbing_wall: AudioStreamPlayer
var splat_sound: AudioStreamPlayer
var exiterror_sound: AudioStreamPlayer
var roll_sound: AudioStreamPlayer
var launchready_sound: AudioStreamPlayer
var highjump_sound: AudioStreamPlayer
var tuck_sound: AudioStreamPlayer

#Creating song variables
var mainmenu_song: AudioStreamPlayer
var level1_song: AudioStreamPlayer
var level1cutscene_song: AudioStreamPlayer
var songs: Array
var music_bus
var current_bus
var fadein = false

var OnStartMenu = true
var PlayerDead = false

func _ready():
	#Declaring sound effect variables
	hover_sound = $HoverSound
	select_sound = $SelectSound
	select_sound_next = $SelectSoundNext
	death_sound = $DeathSound
	levelcomplete_sound = $LevelComplete
	jumplanding_sound = $JumpLandingSound
	jump_sound = $JumpSound
	pause_sound = $PauseSound
	resume_sound = $ResumeSound
	footsteps = $Footsteps
	rummaging_sound = $RummagingSound
	itemcollected_sound = $ItemCollectedSound
	bush_sound = $BushSound
	climbing_pole = $ClimbingPole
	climbing_wall = $ClimbingWall
	splat_sound = $Splat
	exiterror_sound = $ExitError
	roll_sound = $RollSound
	launchready_sound = $LaunchReadySound
	highjump_sound = $HighJumpSound
	tuck_sound = $TuckSound
	
	mainmenu_song = $MainMenuSong
	level1_song = $Level1Song
	level1cutscene_song = $Level1CutsceneSong
	
	songs = [mainmenu_song, level1_song, level1cutscene_song] #Array to store all songs to easily stop the currently playing track later
	
	music_bus = AudioServer.get_bus_index("Music")
	current_bus = AudioServer.get_bus_index("CurrentSong")
	
	#Connecting signals to functions
	player_died.connect(on_player_died)
	level_complete.connect(on_level_complete)
	player_landed.connect(on_player_landed)
	player_jumped.connect(on_player_jumped)
	player_tuck.connect(on_player_tuck)
	player_roll.connect(on_player_roll)
	player_highjump.connect(on_player_highjump)
	player_rummaging.connect(on_player_rummaging)
	player_rummagingstop.connect(on_player_rummagingstop)
	player_itemcollected.connect(on_player_itemcollected)
	player_brushpast.connect(on_player_brushpast)
	player_launchready.connect(on_player_launchready)
	game_paused.connect(on_game_paused)
	game_resumed.connect(on_game_resumed)
	scene_changed.connect(on_scene_changed)
	footstep_run.connect(on_footstep_run)
	footstep_crawl.connect(on_footstep_crawl)
	footstep_climbingpole.connect(on_footstep_climbingpole)
	footstep_climbingwall.connect(on_footstep_climbingwall)
	splat.connect(on_splat)
	exit_error.connect(on_exit_error)
	PlayerDeadSetFalse.connect(on_PlayerDeadSetFalse)

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

#Function to play button noises across all scenes
func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(PlayHover)
		
		if get_tree().get_current_scene().get_name() == "LevelOneCutscene":
			node.pressed.connect(PlayPressed)
		elif node.name == "PauseButton" or node.name == "ResumeButton":
			pass
		else:
			node.pressed.connect(PlayPressed)

func _process(delta):
	if fadein:
		AudioServer.set_bus_volume_db(music_bus, AudioServer.get_bus_volume_db(music_bus) - 60 * delta)
		AudioServer.set_bus_volume_db(current_bus, AudioServer.get_bus_volume_db(current_bus) + 65 * delta)
		
		if AudioServer.get_bus_volume_db(current_bus) >= 0:
			var OldSong = get_current_song()
			var NewSong = get_next_song()
			if is_instance_valid(OldSong):
				OldSong.stop()
			NewSong.set_bus("Music")
			
			AudioServer.set_bus_volume_db(music_bus, 0)
			AudioServer.set_bus_volume_db(current_bus, -60)
			
			fadein = false

# Function to smoothly transition between two songs
func transition_songs(current_song: AudioStreamPlayer, next_song: AudioStreamPlayer):
	if fadein == true:
		fadein = false
		reset_songs()
		if is_instance_valid(current_song):
			current_song.play()
		AudioServer.set_bus_volume_db(music_bus, 0)
	
	next_song.set_bus("CurrentSong")
	AudioServer.set_bus_volume_db(current_bus, -60)
	next_song.play()
	
	fadein = true
	return

#Function to get currently playing song
func get_current_song():
	for song in songs:
		if song.is_playing() and song.get_bus() == "Music":
			return song

#Function to check which song is playing on the CurrentBus
func get_next_song():
	for song in songs:
		if song.get_bus() == "CurrentSong":
			return song

func reset_songs():
	for song in songs:
		song.set_bus("Music")
		song.stop()

#Detect scene changes and change music accordingly
func on_scene_changed(scene_path):
	#If entering start screen or level select screen for the first time then stop previous music and play main menu music
	if (scene_path == "res://ui/start_screen.tscn") and OnStartMenu == false:
		OnStartMenu = true
		transition_songs(get_current_song(), mainmenu_song)
		return
	#If entering start screen or level select screen not for the first time then do nothing
	elif (scene_path == "res://ui/level_select_screen.tscn" or scene_path == "res://ui/start_screen.tscn" or scene_path == "res://ui/credits.tscn") and OnStartMenu == true:
		#Do nothing
		return
	#If entering level 1 cutscene, stop current music and play level 1 cutscene music
	elif scene_path == "res://levels/level_1_cutscene.tscn":
		transition_songs(get_current_song(), level1cutscene_song)
	#If entering level 1 scene, stop current music and play level 1 music
	elif scene_path == "res://levels/level_1.tscn":
		transition_songs(get_current_song(), level1_song)
	
	OnStartMenu = false

#Play event sound effects
func on_player_died():
	death_sound.play()
	PlayerDead = true

func on_level_complete():
	levelcomplete_sound.play()

func on_player_landed():
	jumplanding_sound.play()

func on_player_jumped():
	jump_sound.play()

func on_player_tuck():
	tuck_sound.play()

func on_player_roll():
	roll_sound.play()

func on_player_highjump():
	highjump_sound.play()

func on_player_rummaging():
	rummaging_sound.play()

func on_player_rummagingstop():
	rummaging_sound.stop()

func on_player_itemcollected():
	itemcollected_sound.play()

func on_player_brushpast():
	bush_sound.play()

func on_player_launchready():
	launchready_sound.play()

func on_footstep_run():
	footsteps.play()

func on_footstep_crawl():
	print()

func on_footstep_climbingpole():
	climbing_pole.play()

func on_footstep_climbingwall():
	climbing_wall.play()

func on_splat():
	splat_sound.play()


func on_game_paused():
	if PlayerDead == false:
		pause_sound.play()

func on_game_resumed():
	if PlayerDead == false:
		resume_sound.play()

func on_exit_error():
	exiterror_sound.play()

func on_PlayerDeadSetFalse():
	PlayerDead = false


#Play button sound functions
func PlayHover() -> void:
	hover_sound.play()

func PlayPressed() -> void:
	select_sound.play()

func PlayPressed2() -> void:
	select_sound_next.play()
