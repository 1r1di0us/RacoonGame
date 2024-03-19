extends CanvasLayer

#@onready var select_sound: AudioStreamPlayer = $SelectSound

@export_file("*.tscn") var target_level_path = ""
@export() var play_exit_animation = true
@export() var play_enter_animation = true

func _on_button_pressed():
	if target_level_path.is_empty(): return
	await(LevelTransitions.play_exit_transition(play_exit_animation))
	GameManager.transition_to_scene(target_level_path)
	LevelTransitions.play_enter_transition(play_enter_animation)
	#select_sound.play()
	
