extends RaccoonState
class_name Wall_Clamber

func physics_update(delta: float):
	if animationPlayer.current_animation_position >= 1.0:
		raccoon.global_position.x += 90 * raccoon.global_scale.x * (-raccoon.locked_facing * 2 + 1) #get him on top of the wall
		finished.emit("Wall_Kick")
	elif Input.is_action_just_pressed("move_down"):
		raccoon.locked_facing = -1
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		raccoon.locked_facing = -1
		if raccoon.facing: raccoon.facing = 0
		else: raccoon.facing = 1
		raccoon.velocity.x = raccoon.SPEED * (-raccoon.facing * 2 + 1) #launch off the wall
		raccoon.jump_off = true
		raccoon.cant_clamber = 0.25
		finished.emit("Jump")
	else:
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = 0

func enter(msg: Dictionary = {}):
	AudioManager.emit_signal("player_clamber")
	if raccoon.mantle_spot != null && "mantle_direction_left" in raccoon.mantle_spot:
		if raccoon.mantle_spot.mantle_direction_left == false:
			animationPlayer.play("wall_clamber")
			raccoon.global_position.x = raccoon.mantle_spot.global_position.x + 32 - 48 * raccoon.global_scale.x
			raccoon.facing = 0
			raccoon.locked_facing = 0
		elif raccoon.mantle_spot.mantle_direction_left == true:
			animationPlayer.play("wall_clamber_flip")
			raccoon.global_position.x = raccoon.mantle_spot.global_position.x - 32 + 48 * raccoon.global_scale.x
			raccoon.facing = 1
			raccoon.locked_facing = 1
	else:
		print("mantle object not correctly set up")
	raccoon.velocity.y = raccoon.WALL_CLAMBER_SPEED
	raccoon.global_position.y = raccoon.mantle_spot.global_position.y + 32 + 120*raccoon.global_scale.y

func exit():
	pass
