extends RaccoonState
class_name Crawl

func physics_update(delta: float):
	if (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1
		&& raccoon.global_position.x >= raccoon.climbable_x - 32
		&& raccoon.global_position.x <= raccoon.climbable_x + 32):
		finished.emit("Pole_Climb")
	elif not raccoon.is_on_floor():
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump") && not Input.is_action_pressed("crouch"):
		finished.emit("Jump")
	elif not Input.is_action_pressed("crouch") && raccoon.platforms <= 0:
		finished.emit("Run")
	elif raccoon.direction == 0:
		finished.emit("Crouch")
	
	if raccoon.prev_facing != raccoon.facing: # we want to flip in the middle of the state
		var temp = animationPlayer.current_animation_position
		if raccoon.facing:
			animationPlayer.play("crawl_flip")
		else:
			animationPlayer.play("crawl")
		animationPlayer.seek(temp, true)
	
	raccoon.velocity.y += raccoon.gravity * delta
	raccoon.velocity.x = move_toward(raccoon.velocity.x, raccoon.direction * raccoon.CRAWL_SPEED, raccoon.ACCELERATION)
	pass

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("crawl_flip")
	else:
		animationPlayer.play("crawl")

func exit():
	pass
