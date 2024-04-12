extends RaccoonState
class_name Launch

func physics_update(delta: float):
	
	if animationPlayer.current_animation_position >= 0.5:
		if not raccoon.is_on_floor():
			finished.emit("Freeball")
		else:
			finished.emit("Roll")
	else:
		raccoon.velocity.y += raccoon.gravity * delta

func enter(msg: Dictionary = {}):
	AudioManager.emit_signal("player_roll")
	
	if raccoon.facing == 1:
		animationPlayer.play("launch_flip")
	else:
		animationPlayer.play("launch")
	if raccoon.locked_facing == -1:
		raccoon.locked_facing = raccoon.facing

func exit():
	pass
