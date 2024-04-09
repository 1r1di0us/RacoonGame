extends player_detect_zone

@export_file("*.tscn") var target_level_path = ""
@export() var play_exit_animation = true
@export() var play_enter_animation = true
@export() var score_threshold: int = 5
@export() var level_instructions = ""

func _ready():
	$LevelInstructions.text = level_instructions
	$LevelInstructions.visible = false
	$FoodRemaining.visible = false

func _on_body_entered(body):
	if not body is Raccoon: return
	if target_level_path.is_empty(): return
	if GameManager.level_score[GameManager.current_level-1] != score_threshold: 
		$LevelInstructions.visible = true
		$FoodRemaining.visible = true
		$FoodRemaining.text = "Come back when you have "+str(score_threshold - GameManager.level_score[GameManager.current_level-1])+ " more!"
		AudioManager.emit_signal("exit_error")
		return
	AudioManager.emit_signal("level_complete")
	get_tree().paused = true
	await(LevelTransitions.play_exit_transition(play_exit_animation))
	GameManager.transition_to_scene(target_level_path)
	#LevelTransitions.reset_transition_animation()
	GameManager.setLevelDone(target_level_path[19].to_int());
	get_tree().paused = false
	#LevelTransitions.play_enter_transition(play_enter_animation)

func _on_body_exited(body):
	$LevelInstructions.visible = false
	$FoodRemaining.visible = false
