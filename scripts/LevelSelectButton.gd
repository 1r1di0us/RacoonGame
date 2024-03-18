extends Button

@export_file("*.tscn") var target_level_path = ""

func _on_pressed():
	GameManager.transition_to_scene(target_level_path)
	LevelTransitions.play_enter_transition(false)
