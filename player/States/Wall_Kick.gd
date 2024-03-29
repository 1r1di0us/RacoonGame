extends RaccoonState
class_name Wall_Kick

func physics_update(delta: float):
	#Idle but with a different animation
	if (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1
		&& raccoon.global_position.x >= raccoon.climbable_x - 32
		&& raccoon.global_position.x <= raccoon.climbable_x + 32):
		finished.emit("Pole_Climb")
	elif (Input.is_action_pressed("move_up")
		&& (raccoon.climbable_walls_right_count > 0
		|| raccoon.climbable_walls_left_count > 0)):
		finished.emit("Wall_Climb")
	elif not raccoon.is_on_floor():
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif Input.is_action_pressed("crouch"):
		finished.emit("Crouch")
	elif not raccoon.direction == 0:
		if raccoon.platforms <= 0:
			finished.emit("Crawl")
		else:
			finished.emit("Run")
	elif animationPlayer.current_animation_position >= 0.4:
		finished.emit("Idle")
	
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
