extends RaccoonState
class_name Pole_Clamber

func physics_update(delta: float):	
	if raccoon.velocity.x != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)
	
	if Input.is_action_just_pressed("move_down"):
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif raccoon.is_on_floor() || raccoon.platforms <= 0:
		if (raccoon.direction == 0):
			finished.emit("Idle")
		else:
			finished.emit("Run")



func enter(msg: Dictionary = {}):
	animationPlayer.play("pole_clamber")
	raccoon.velocity.y = raccoon.CLAMBER_SPEED
	raccoon.global_position.y = raccoon.clamber_y + 32

func exit():
	pass
