extends RaccoonState
class_name Freefall

func physics_update(delta: float):
	if raccoon.is_on_floor():
		if raccoon.direction != 0:
			if Input.is_action_pressed("crouch"):
				finished.emit("Crawl")
			else:
				finished.emit("Run")
		else:
			if Input.is_action_pressed("crouch"):
				finished.emit("Crouch")
			else:
				finished.emit("Idle")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Tuck")
	
	if raccoon.prev_facing != raccoon.facing: # we want to flip in the middle of the state
		var temp = animationPlayer.current_animation_position
		if raccoon.facing:
			animationPlayer.play("freefall_flip")
		else:
			animationPlayer.play("freefall")
		animationPlayer.seek(temp, true)
	
	raccoon.velocity.y += raccoon.gravity * delta
	if raccoon.direction != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, raccoon.direction * raccoon.SPEED, raccoon.ACCELERATION)
	else:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("freefall_flip")
	else:
		animationPlayer.play("freefall")

func exit():
	pass
