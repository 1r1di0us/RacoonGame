extends Node
#currently preloads level 1 from the start screen
#change to load main menu later
#var level_1 = preload("res://levels/level_1.tscn")
var pause_screen = preload("res://ui/pause_screen.tscn")
var start_screen = preload("res://ui/start_screen.tscn")
var game_over_screen = preload("res://ui/game_over_screen.tscn")

#flags for level completion- only saved per game instance
var level_flags = [true, false, false]

func setLevelDone(i):
	#want to load level i next
	#reset score of previous level e.g level 2 next, so reset level 1 in position 0
	level_score[i-2] = 0
	#unlock level in level select screen
	level_flags[i-1] = true
	current_level = i

func isLevelDone(i):
	return level_flags[i-1];

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_game():
	current_level = 1
	transition_to_scene("res://levels/level_1_cutscene.tscn")

func exit_game():
	get_tree().quit()

func main_menu():
	if get_tree().paused==true:
		get_tree().paused = false
	current_level = 0
	transition_to_scene(start_screen.resource_path)

func pause_game(type):
	if get_tree().paused == false:
		#game is not paused, so pause it and show the pause screen
		AudioManager.emit_signal("game_paused")
		get_tree().paused = true
		var screen_type
		if (type == 0):
			screen_type = pause_screen.instantiate()
		else: #type == 1
			screen_type = game_over_screen.instantiate()
			#TODO send signal to Raccoon to play game over animation
		get_tree().get_root().add_child(screen_type)
	else:
		#game is paused, so unpause it and hide the pause screen
		AudioManager.emit_signal("game_resumed")
		#$PauseScreen.hide()
		get_tree().paused = false
		

#use this function to load levels
func transition_to_scene(scene_path):
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(scene_path)
	AudioManager.emit_signal("scene_changed", scene_path)
