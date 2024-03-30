extends RaccoonState
class_name Freefall

func physics_update(delta: float):
	if (Input.is_action_pressed("move_up") && raccoon.platforms >= 1 && raccoon.cant_clamber == 0
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
	elif Input.is_action_just_pressed("jump"):
		if raccoon.coyote_time > 0:
			finished.emit("Jump")
		else:
			finished.emit("Tuck")
	elif raccoon.is_on_floor():
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
