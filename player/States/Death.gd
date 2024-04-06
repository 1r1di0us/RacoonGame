extends RaccoonState
class_name Death

func physics_update(delta: float):
	raccoon.velocit.x = 0
	raccoon.velocity.y += raccoon.gravity * delta
	if animationPlayer.current_animation_position >= 0.6:
		raccoon.global_position = raccoon.respawn_pos
		finished.emit("Idle")
		#raccoon.health -= 1

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("death_flip")
	else:
		animationPlayer.play("death")
	if raccoon.locked_facing != -1:
		raccoon.locked_facing = -1

func exit():
	pass
