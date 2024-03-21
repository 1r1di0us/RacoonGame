extends RaccoonState
class_name Idle

func physics_update(delta: float):
	if not raccoon.is_on_floor():
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif Input.is_action_pressed("crouch"):
		finished.emit("Crouch")
	elif not raccoon.direction == 0:
		finished.emit("Run")
	
	raccoon.velocity.y += raccoon.gravity * delta
	if raccoon.velocity.x != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("idle_flip")
	else:
		animationPlayer.play("idle")

func exit():
	pass
