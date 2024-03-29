extends RaccoonState
class_name Freeball

const ROLL_THRESHOLD = 500.0 # moving faster than this on the x allows rolling if we don't splat
const SPLAT_THRESHOLD = 1000.0 # falling faster than this splats

func physics_update(delta: float):
	
	if raccoon.is_on_floor():
		# in the future, check if we land on a ramp
		if raccoon.prevVelY < SPLAT_THRESHOLD && raccoon.velocity.x > ROLL_THRESHOLD:
			finished.emit("Roll")
		else:
			if raccoon.prevVelY >= SPLAT_THRESHOLD:
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
	
	raccoon.velocity.y += raccoon.gravity * delta
	# Can't Push anymore but air is less resistant
	raccoon.velocity.x -= raccoon.velocity.x * 0.5 * delta

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("roll_flip")
	else:
		animationPlayer.play("roll")
	if raccoon.locked_facing == -1:
		raccoon.locked_facing = raccoon.facing

func exit():
	pass
