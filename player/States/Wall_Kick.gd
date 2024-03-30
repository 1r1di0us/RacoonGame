extends RaccoonState
class_name Wall_Kick

func physics_update(delta: float):
	if animationPlayer.current_animation_position >= 0.6:
		if raccoon.platforms >= 1:
			finished.emit("Crouch")
		else:
			finished.emit("Idle")
	elif Input.is_action_just_pressed("jump") && animationPlayer.current_animation_position >= 0.2:
		finished.emit("Jump")
	elif Input.is_action_pressed("crouch") && animationPlayer.current_animation_position >= 0.2:
		finished.emit("Crouch")
	elif not raccoon.direction == 0 && animationPlayer.current_animation_position >= 0.2:
		if raccoon.platforms <= 0:
			finished.emit("Crawl")
		else:
			finished.emit("Run")
	else:
		raccoon.velocity.y += raccoon.gravity * delta
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.locked_facing == 0:
		animationPlayer.play("wall_kick")
	elif raccoon.locked_facing == 1:
		animationPlayer.play("wall_kick_flip")
	raccoon.locked_facing = -1

func exit():
	pass
