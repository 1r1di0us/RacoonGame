extends RaccoonState
class_name Pole_Climb

func physics_update(delta: float):
	if Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	
	if Input.is_action_pressed("move_up") && not Input.is_action_pressed("move_down"):
		animationPlayer.play()
		raccoon.velocity.y -= raccoon.CLIMB_SPEED * delta
	elif Input.is_action_pressed("move_down") && not Input.is_action_pressed("move_up"):
		animationPlayer.play_backwards()
		raccoon.velocity.y += raccoon.CLIMB_SPEED * delta
	else:
		animationPlayer.pause()
	
	if raccoon.velocity.x != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	animationPlayer.play("pole_climb")

func exit():
	pass
