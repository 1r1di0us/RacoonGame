extends RaccoonState
class_name Pole_Clamber

func physics_update(delta: float):	
	if Input.is_action_just_pressed("move_down"):
		finished.emit("Freefall")
	elif Input.is_action_just_pressed("jump"):
		raccoon.velocity.x = raccoon.SPEED * (-raccoon.facing * 2 + 1) #launch off the pole
		raccoon.jump_off = true
		raccoon.cant_clamber = 0.25
		finished.emit("Jump")
	#elif raccoon.is_on_floor() || raccoon.platforms <= 0:
	#	raccoon.idle_fall = 0.25
	#	if (raccoon.direction == 0):
	#		finished.emit("Idle")
	#	else:
	#		finished.emit("Run")
	elif animationPlayer.current_animation_position >= 1.0:
		raccoon.idle_fall = 0.25
		if (raccoon.direction == 0):
			finished.emit("Crouch")
		else:
			finished.emit("Crawl")
	else:
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	animationPlayer.play("pole_clamber")
	raccoon.velocity.y = raccoon.CLAMBER_SPEED
	raccoon.global_position.y = raccoon.clamber_y - 32 + 120*raccoon.scale.y

func exit():
	pass
