extends RaccoonState
class_name Tuck

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
	elif animationPlayer.current_animation_position >= 0.3:
		finished.emit("Freeball")
	
	raccoon.velocity.y += raccoon.gravity * delta
	raccoon.velocity.x -= raccoon.velocity.x * 0.5 * delta

func enter(msg: Dictionary = {}):
	if raccoon.velocity.y >= raccoon.TUCK_VELOCITY: #raccoon not going faster than tuck velocity
		raccoon.velocity.y = raccoon.TUCK_VELOCITY
	raccoon.jump_sound.play() #Play Jump Sound
	
	if raccoon.facing == 1:
		animationPlayer.play("launch_flip") #launch and tuck are the same for now
	else:
		animationPlayer.play("launch")
	if raccoon.locked_facing == -1:
		raccoon.locked_facing = raccoon.facing

func exit():
	pass
