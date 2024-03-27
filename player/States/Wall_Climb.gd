extends RaccoonState
class_name Wall_Climb

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
		#animationPlayer.play("wall_clamber")
		raccoon.velocity.y = -160
		raccoon.clambering = true
		
	if (raccoon.clambering && raccoon.platforms <= 0):
		finished.emit("Idle")


func enter(msg: Dictionary = {}):
	if (raccoon.climbable_walls_right_count > 0):
		animationPlayer.play("wall_climb")
	elif (raccoon.climbable_walls_left_count > 0): #shouldn't be in both kinds
		animationPlayer.play("wall_climb_flip")
	else:
		finished.emit("Idle")

func exit():
	raccoon.clambering = false
