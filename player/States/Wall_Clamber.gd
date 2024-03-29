extends RaccoonState
class_name Wall_Clamber

func physics_update(delta: float):
	if (raccoon.climbable_walls_right_count > 0):
		raccoon.global_position.x = raccoon.climbable_x - 48 * raccoon.global_scale.x #I am confuse I thought it was 80*0.6 = 48 not 48*0.6 = 28.8
	elif (raccoon.climbable_walls_left_count > 0):
		raccoon.global_position.x = raccoon.climbable_x + 48 * raccoon.global_scale.x #add 0.00003 to make it not catch on corners
	
	if raccoon.velocity.x != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)
	
	if Input.is_action_just_pressed("move_down"):
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		raccoon.locked_facing = -1
		raccoon.facing = !raccoon.facing
		raccoon.velocity.x = raccoon.SPEED * (-raccoon.facing * 2 + 1) #launch off the wall
		raccoon.jump_off = true
		finished.emit("Jump")
	if animationPlayer.current_animation_position >= 1.0:
		raccoon.global_position.x += 150 * raccoon.global_scale.x * raccoon.facing #get him on top of the wall
		finished.emit("Wall_Kick")

func enter(msg: Dictionary = {}):
	if (raccoon.climbable_walls_right_count > 0):
		animationPlayer.play("wall_clamber")
		raccoon.global_position.x = raccoon.climbable_x - 48 * raccoon.global_scale.x
		raccoon.facing = 0
		raccoon.locked_facing = 0
	elif (raccoon.climbable_walls_left_count > 0):
		animationPlayer.play("wall_clamber_flip")
		raccoon.global_position.x = raccoon.climbable_x + 48 * raccoon.global_scale.x #add 0.00003 to make it not catch on corners
		raccoon.facing = 1
		raccoon.locked_facing = 1
	raccoon.velocity.y = raccoon.CLAMBER_SPEED
	raccoon.global_position.y = raccoon.clamber_y + 32 + 200*raccoon.global_scale.y

func exit():
	pass
