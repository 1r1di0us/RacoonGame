extends RaccoonState
class_name Splat

var timer = 0

func physics_update(delta: float):
	if timer == 0:
		finished.emit("Idle")
	else:
		if timer <= delta:
			timer = 0
		else:
			timer -= delta
		
		raccoon.velocity.y += raccoon.gravity * delta
		if raccoon.velocity.x != 0:
			raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 0:
		animationPlayer.play("splat")
	else:
		animationPlayer.play("splat_flip")
	timer = 0.5
	raccoon.locked_facing = -1

func exit():
	pass
