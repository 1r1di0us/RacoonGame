extends CanvasLayer

@onready var animationPlayer = $AnimationPlayer

func play_enter_transition(play:bool):
	if(play):
		animationPlayer.play("enter_level")
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false

func play_exit_transition(play:bool):
	get_tree().paused = true
	if(play):
		animationPlayer.play("exit_level")
	await get_tree().create_timer(0.5).timeout
