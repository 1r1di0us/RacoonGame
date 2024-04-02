extends Node
#currently preloads level 1 from the start screen
#change to load main menu later
#var level_1 = preload("res://levels/level_1.tscn")
var pause_screen = preload("res://ui/pause_screen.tscn")
var start_screen = preload("res://ui/start_screen.tscn")
var game_over_screen = preload("res://ui/game_over_screen.tscn")

#flags for level completion- only saved per game instance
var level_flags = [true, false, false]

var level_score = [0,0,0]

func setLevelDone(i):
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
		#$PauseScreen.hide()
		get_tree().paused = false
		

#use this function to load levels
func transition_to_scene(scene_path):
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(scene_path)
	

func add_score(score):
	level_score[current_level-1] += score
