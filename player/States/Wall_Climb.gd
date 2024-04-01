extends RaccoonState
class_name Wall_Climb

func physics_update(delta: float):
	if Input.is_action_just_pressed("jump"):
		raccoon.locked_facing = -1
		if raccoon.climbable_walls_right_count > 0:
			raccoon.facing = 1
		else: #climbable_walls_left_count > 0
			raccoon.facing = 0
		raccoon.velocity.x = raccoon.SPEED * (-raccoon.facing * 2 + 1) #launch off the wall
		raccoon.jump_off = true
		raccoon.cant_clamber = 0.25
		finished.emit("Jump")
	elif raccoon.is_on_floor():
		raccoon.locked_facing = -1
		finished.emit("Idle")
	elif (Input.is_action_pressed("move_up")
		&& raccoon.platforms >= 1 && raccoon.global_position.x >= raccoon.clamber_x - 48*raccoon.global_scale.x
		&& raccoon.global_position.x <= raccoon.clamber_x + 48*raccoon.global_scale.x):
		raccoon.locked_facing = -1
		finished.emit("Pole_Clamber") #If there is a platform at the top of the wall
	elif (raccoon.climbable_walls_right_count + raccoon.climbable_walls_left_count == 0):
		raccoon.locked_facing = -1
		finished.emit("Idle")
	elif Input.is_action_pressed("move_up") && raccoon.mantle_spot != null:
		finished.emit("Wall_Clamber")
	else:
		if (raccoon.climbable_walls_right_count > 0):
			raccoon.global_position.x = raccoon.climbable_x - 48 * raccoon.global_scale.x #I am confuse I thought it was 80*0.6 = 48 not 48*0.6 = 28.8
		elif (raccoon.climbable_walls_left_count > 0):
			raccoon.global_position.x = raccoon.climbable_x + 48 * raccoon.global_scale.x #add 0.00003 to make it not catch on corners
		
		if Input.is_action_pressed("move_up") && not Input.is_action_pressed("move_down"):
			animationPlayer.play()
			raccoon.velocity.y = -raccoon.CLIMB_SPEED
		elif Input.is_action_pressed("move_down") && not Input.is_action_pressed("move_up"):
			animationPlayer.play_backwards()
			raccoon.velocity.y = raccoon.CLIMB_SPEED
		else:
			animationPlayer.pause()
			raccoon.velocity.y = 0
		
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if (raccoon.climbable_walls_right_count > 0):
		animationPlayer.play("wall_climb")
		raccoon.global_position.x = raccoon.climbable_x - 48 * raccoon.global_scale.x
		raccoon.facing = 0
		raccoon.locked_facing = 0
	elif (raccoon.climbable_walls_left_count > 0):
		animationPlayer.play("wall_climb_flip")
		raccoon.global_position.x = raccoon.climbable_x + 48 * raccoon.global_scale.x #add 0.00003 to make it not catch on corners
		raccoon.facing = 1
		raccoon.locked_facing = 1
	raccoon.global_position.y -= 10
	#else why are we here
	

func exit():
	pass
