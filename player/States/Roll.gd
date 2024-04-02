extends RaccoonState
class_name Roll

func physics_update(delta: float):
	if not raccoon.is_on_floor():
		raccoon.cant_clamber = 0.25
		raccoon.coyote_time = 0.1
		finished.emit("Freeball")
	elif Input.is_action_just_pressed("jump") && raccoon.is_on_floor():
		raccoon.locked_facing = -1
		raccoon.velocity.y = -max(abs(raccoon.velocity.x), -raccoon.JUMP_VELOCITY) - raccoon.gravity * delta
		finished.emit("High_Jump")
	elif abs(raccoon.velocity.x) <= raccoon.STOP_THRESHOLD:
		raccoon.locked_facing = -1
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
	elif (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1
		&& raccoon.global_position.x >= raccoon.climbable_x - 32
		&& raccoon.global_position.x <= raccoon.climbable_x + 32):
		finished.emit("Pole_Climb")
	elif (Input.is_action_pressed("move_up")
		&& (raccoon.climbable_walls_right_count > 0
		|| raccoon.climbable_walls_left_count > 0)):
		finished.emit("Wall_Climb")
	else:
		raccoon.velocity.y += raccoon.gravity * delta
		# Push the roll by a constant while multiplicatively reducing speed.
		raccoon.velocity.x += ((raccoon.ROLL_PUSH * raccoon.direction) - (raccoon.velocity.x * 0.75)) * delta

func enter(msg: Dictionary = {}):
	if raccoon.locked_facing == -1: # make sure the direction is locked
		if raccoon.facing == 1:
			animationPlayer.play("roll_flip")
		else:
			animationPlayer.play("roll")
		raccoon.locked_facing = raccoon.facing
	else:
		if raccoon.locked_facing == 1:
			animationPlayer.play("roll_flip")
		else:
			animationPlayer.play("roll")

func exit():
	pass
