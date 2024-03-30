extends RaccoonState
class_name Idle

func physics_update(delta: float):
	if raccoon.platforms >= 1:
		finished.emit("Crouch")
	elif (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1
		&& raccoon.global_position.x >= raccoon.climbable_x - 32
		&& raccoon.global_position.x <= raccoon.climbable_x + 32):
		finished.emit("Pole_Climb")
	elif (Input.is_action_pressed("move_up")
		&& (raccoon.climbable_walls_right_count > 0
		|| raccoon.climbable_walls_left_count > 0)):
		finished.emit("Wall_Climb")
	elif not raccoon.is_on_floor() && raccoon.idle_fall == 0:
		raccoon.cant_clamber = 0.25
		raccoon.coyote_time = 0.1
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	#elif raccoon.is_near_rummagable != {} && Input.is_action_just_pressed("interact"):
	#	finished.emit("Rummage")
	elif Input.is_action_pressed("crouch"):
		finished.emit("Crouch")
	elif not raccoon.direction == 0:
		if raccoon.platforms <= 0:
			finished.emit("Crawl")
		else:
			finished.emit("Run")
	else:
		raccoon.velocity.y += raccoon.gravity * delta
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("idle_flip")
	else:
		animationPlayer.play("idle")

func exit():
	pass
