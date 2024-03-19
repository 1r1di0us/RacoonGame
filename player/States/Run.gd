extends RaccoonState
class_name Run

func physics_update(delta: float):
	if not raccoon.is_on_floor():
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif Input.is_action_pressed("crouch"):
		finished.emit("Crawl")
	elif raccoon.direction == 0:
		finished.emit("Idle")
	
	if raccoon.prev_facing != raccoon.facing: # we want to flip in the middle of the state
		var temp = animationPlayer.current_animation_position
		if raccoon.facing:
			animationPlayer.play("run_flip")
		else:
			animationPlayer.play("run")
		animationPlayer.seek(temp, true)
	
	raccoon.velocity.y += raccoon.gravity * delta
	raccoon.velocity.x = move_toward(raccoon.velocity.x, raccoon.direction * raccoon.SPEED, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("run_flip")
	else:
		animationPlayer.play("run")

func exit():
	pass