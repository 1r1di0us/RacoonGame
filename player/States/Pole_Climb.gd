extends RaccoonState
class_name Pole_Climb

func physics_update(delta: float):
	raccoon.global_position.x = raccoon.climbable_x
		
	if Input.is_action_pressed("move_up") && not Input.is_action_pressed("move_down"):
		animationPlayer.play()
		raccoon.velocity.y = -raccoon.CLIMB_SPEED
	elif Input.is_action_pressed("move_down") && not Input.is_action_pressed("move_up"):
		animationPlayer.play_backwards()
		raccoon.velocity.y = raccoon.CLIMB_SPEED
	else:
		animationPlayer.pause()
		raccoon.velocity.y = 0
	
	if raccoon.velocity.x != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)
	
	if Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif raccoon.is_on_floor():
		finished.emit("Idle")
	elif Input.is_action_pressed("move_up") && raccoon.platforms >= 1 && raccoon.global_position.x >= raccoon.clamber_x - 32 && raccoon.global_position.x <= raccoon.clamber_x + 32:
		finished.emit("Pole_Clamber")

func enter(msg: Dictionary = {}):
	animationPlayer.play("pole_climb")
	raccoon.global_position.x = raccoon.climbable_x

func exit():
	pass
