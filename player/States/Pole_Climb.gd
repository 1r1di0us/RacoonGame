extends RaccoonState
class_name Pole_Climb

func physics_update(delta: float):
	
	if (!raccoon.clambering):
		
		if Input.is_action_pressed("move_up") && not Input.is_action_pressed("move_down"):
			animationPlayer.play()
			raccoon.velocity.y = -raccoon.CLIMB_SPEED
		elif Input.is_action_pressed("move_down") && not Input.is_action_pressed("move_up"):
			animationPlayer.play_backwards()
			raccoon.velocity.y = raccoon.CLIMB_SPEED
		else:
			animationPlayer.pause()
			raccoon.velocity.y = 0
	else:
		if Input.is_action_just_pressed("move_down"):
			animationPlayer.stop()
			finished.emit("Freefall")
	
	if raccoon.velocity.x != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)
	
	if Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif raccoon.is_on_floor():
		finished.emit("Idle")
	elif raccoon.platforms >= 2:
		animationPlayer.play("pole_clamber")
		raccoon.velocity.y = -160
		raccoon.clambering = true
		
	if (raccoon.clambering && raccoon.platforms <= 0):
		finished.emit("Idle")


func enter(msg: Dictionary = {}):
	animationPlayer.play("pole_climb")

func exit():
	raccoon.clambering = false
