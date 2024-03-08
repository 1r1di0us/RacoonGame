extends CanvasLayer

@onready var animationPlayer = $AnimationPlayer

func play_enter_transition():
	await get_tree().create_timer(0.5).timeout
	animationPlayer.play("enter_level")
	get_tree().paused = false

func play_exit_transition():
	get_tree().paused = true
	animationPlayer.play("exit_level")
	await get_tree().create_timer(0.5).timeout
