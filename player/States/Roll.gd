extends RaccoonState
class_name Roll

const STOP_THRESHOLD = 200.0

func physics_update(delta: float):
		
	if not raccoon.is_on_floor():
		finished.emit("Freeball")
	elif Input.is_action_just_pressed("jump") && raccoon.is_on_floor():
		#have to multiply the velocity because otherwise its terrible
		raccoon.locked_facing = -1
		raccoon.velocity.y = -max(abs(raccoon.velocity.x) * 1.25, -raccoon.JUMP_VELOCITY) - raccoon.gravity * delta
		finished.emit("High_Jump")
	elif abs(raccoon.velocity.x) <= STOP_THRESHOLD:
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
