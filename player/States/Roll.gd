extends RaccoonState
class_name Roll

const STOP_THRESHOLD = 75

func physics_update(delta: float):
	#TODO: Add Launch state
	
	if not raccoon.is_on_floor:
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump") && raccoon.is_on_floor():
		raccoon.velocity.y = -max(abs(raccoon.velocity.x) * 1.25, -raccoon.JUMP_VELOCITY) - raccoon.gravity * delta
		finished.emit("High_Jump")
	elif abs(raccoon.velocity.x) <= STOP_THRESHOLD:
		raccoon.locked_dir = 0
		finished.emit("Idle")
	
	#WE DON'T FLIP FOR NOW
	#if raccoon.prev_facing != raccoon.facing: # we want to flip in the middle of the state
		#var temp = animationPlayer.current_animation_position
		#if raccoon.facing:
			#animationPlayer.play("roll_flip")
		#else:
			#animationPlayer.play("roll")
		#animationPlayer.seek(temp, true)
	
	raccoon.velocity.y += raccoon.gravity * delta
	# Push the roll by a constant while multiplicatively reducing speed.
	raccoon.velocity.x += (raccoon.ROLL_PUSH * raccoon.direction) - (raccoon.velocity.x * 0.02)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("roll_flip")
	else:
		animationPlayer.play("roll")
	raccoon.locked_dir = raccoon.direction

func exit():
	pass
