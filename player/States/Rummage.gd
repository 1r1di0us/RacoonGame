extends RaccoonState
class_name Rummage

var timer = 0

func physics_update(delta: float):
	if not Input.is_action_pressed("interact"):
		timer = 0
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
	elif timer <= delta:
		timer = 0
		raccoon.is_near_rummagable.rummage()
		#change raccoon's food meter
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
	else:
		timer -= delta
		raccoon.velocity.y += raccoon.gravity * delta
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	AudioManager.emit_signal("player_rummaging")
	if raccoon.facing == 1:
		animationPlayer.play("rummage_flip")
	else:
		animationPlayer.play("rummage")
	timer = 1.5
	
func exit():
	AudioManager.emit_signal("player_rummagingstop")
	pass
