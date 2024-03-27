extends RaccoonState
class_name Jump

func physics_update(delta: float):
	if (Input.is_action_pressed("move_up") && raccoon.platforms >= 1
		&& raccoon.global_position.x >= raccoon.clamber_x - 32
		&& raccoon.global_position.x <= raccoon.clamber_x + 32):
		finished.emit("Pole_Clamber")
	elif (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1
		&& raccoon.global_position.x >= raccoon.climbable_x - 32
		&& raccoon.global_position.x <= raccoon.climbable_x + 32):
		finished.emit("Pole_Climb")
	elif raccoon.is_on_floor():
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
	elif animationPlayer.current_animation_position >= 0.6:
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Tuck")

	if raccoon.prev_facing != raccoon.facing: # we want to flip in the middle of the state
		var temp = animationPlayer.current_animation_position
		if raccoon.facing:
			animationPlayer.play("jump_flip")
		else:
			animationPlayer.play("jump")
		animationPlayer.seek(temp, true)
	
	raccoon.velocity.y += raccoon.gravity * delta
	if raccoon.direction != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, raccoon.direction * raccoon.SPEED, raccoon.ACCELERATION)
	else:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)
	
	if Input.is_action_just_released("jump") && raccoon.velocity.y < 0:
		raccoon.velocity.y = 0
		animationPlayer.seek(0.4, true)

func enter(msg: Dictionary = {}):
	raccoon.velocity.y = raccoon.JUMP_VELOCITY
	AudioManager.emit_signal("player_jumped")
	
	if raccoon.facing == 1:
		animationPlayer.play("jump_flip")
	else:
		animationPlayer.play("jump")

func exit():
	pass
