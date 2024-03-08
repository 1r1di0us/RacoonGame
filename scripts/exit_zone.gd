extends Area2D

@export_file("*.tscn") var target_level_path = ""

func _on_body_entered(body):
	if not body is Raccoon: return
	if target_level_path.is_empty(): return
	await(LevelTransitions.play_exit_transition())
	GameManager.transition_to_scene(target_level_path)
	LevelTransitions.play_enter_transition()
	
