extends RaccoonState
class_name Rummage

var timer = 0

func _physics_process(delta: float):
	if timer <= delta:
		timer = 0
		#print("SUCCESSFUL RUMMAGE (what do I do)")
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
	elif not Input.is_action_pressed("interact"):
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
	else:
		timer -= delta
		raccoon.velocity.y += raccoon.gravity * delta
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	animationPlayer.play("rummage")
	timer = 1.5
	
func exit():
	pass
