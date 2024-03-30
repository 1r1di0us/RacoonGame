extends RaccoonState
class_name Freeball

func physics_update(delta: float):
	if Input.is_action_just_pressed("jump") && raccoon.coyote_time > 0:
		raccoon.locked_facing = -1
		raccoon.velocity.y = -max(abs(raccoon.velocity.x), -raccoon.JUMP_VELOCITY) - raccoon.gravity * delta
		finished.emit("High_Jump")
	elif (Input.is_action_pressed("move_up") && raccoon.platforms >= 1 && raccoon.cant_clamber == 0
		&& raccoon.global_position.x >= raccoon.clamber_x - 32
		&& raccoon.global_position.x <= raccoon.clamber_x + 32
		&& raccoon.global_position.y >= raccoon.clamber_y  - 32):
		finished.emit("Pole_Clamber")
	elif (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1 && raccoon.cant_clamber == 0
		&& raccoon.global_position.x >= raccoon.climbable_x - 32
		&& raccoon.global_position.x <= raccoon.climbable_x + 32):
		finished.emit("Pole_Climb")
	elif (raccoon.mantle_spot != null && raccoon.cant_clamber == 0
		&& raccoon.global_position.y - raccoon.collisionBox.size.y / 2 >= raccoon.mantle_spot.global_position.y):
		finished.emit("Wall_Clamber")
	elif (Input.is_action_pressed("move_up") && raccoon.cant_clamber == 0
		&& (raccoon.climbable_walls_right_count > 0
		|| raccoon.climbable_walls_left_count > 0)):
		finished.emit("Wall_Climb")
	elif raccoon.is_on_floor():
		# in the future, check if we land on a ramp
		if raccoon.prevVelY < raccoon.SPLAT_THRESHOLD && raccoon.velocity.x > raccoon.ROLL_THRESHOLD:
			finished.emit("Roll")
		else:
			if raccoon.prevVelY >= raccoon.SPLAT_THRESHOLD:
				finished.emit("Splat")
			else:
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
	else:
		raccoon.velocity.y += raccoon.gravity * delta
		# less push but less resistance
		raccoon.velocity.x += ((raccoon.ROLL_PUSH * 0.5 * raccoon.direction) - (raccoon.velocity.x * 0.75)) * delta

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("roll_flip")
	else:
		animationPlayer.play("roll")
	if raccoon.locked_facing == -1:
		raccoon.locked_facing = raccoon.facing

func exit():
	pass
