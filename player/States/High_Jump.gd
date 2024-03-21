extends RaccoonState
class_name High_Jump

func physics_update(delta: float):
	if raccoon.is_on_floor():
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
	elif animationPlayer.current_animation_position >= 0.6:
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Tuck")

	if raccoon.prev_facing != raccoon.facing: # we want to flip in the middle of the state
		var temp = animationPlayer.current_animation_position
		if raccoon.facing:
			animationPlayer.play("jump_flip")
		else:
			animationPlayer.play("jump")
		animationPlayer.seek(temp, true)
	
	raccoon.velocity.y += raccoon.gravity * delta
	raccoon.velocity.x = raccoon.direction * raccoon.HIGH_JUMP_VELOCITY_X
	
	if Input.is_action_just_released("jump") && raccoon.velocity.y < 0:
		raccoon.velocity.y = 0
		animationPlayer.seek(0.4, true)

func enter(msg: Dictionary = {}):
	AudioManager.emit_signal("player_jumped") #Play Jump Sound
	#y velocity determined by previous state
	
	if raccoon.facing == 1:
		animationPlayer.play("jump_flip")
	else:
		animationPlayer.play("jump")

func exit():
	pass
