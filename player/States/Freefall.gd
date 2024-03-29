extends RaccoonState
class_name Freefall

func physics_update(delta: float):
	if (Input.is_action_pressed("move_up") && raccoon.platforms >= 1
		&& raccoon.global_position.x >= raccoon.clamber_x - 32
		&& raccoon.global_position.x <= raccoon.clamber_x + 32
		&& raccoon.global_position.y >= raccoon.clamber_y  - 32):
		finished.emit("Pole_Clamber")
	elif (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1
		&& raccoon.global_position.x >= raccoon.climbable_x - 32
		&& raccoon.global_position.x <= raccoon.climbable_x + 32):
		finished.emit("Pole_Climb")
	elif (Input.is_action_pressed("move_up")
		&& (raccoon.climbable_walls_right_count > 0
		|| raccoon.climbable_walls_left_count > 0)):
		finished.emit("Wall_Climb")
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
