extends RaccoonState
class_name Launch

func physics_update(delta: float):
	
	if not raccoon.is_on_floor():
		finished.emit("Freeball")
	elif animationPlayer.current_animation_position >= 0.3:
		finished.emit("Roll")
	
	raccoon.velocity.y += raccoon.gravity * delta
	raccoon.velocity.x -= raccoon.velocity.x * 0.75 * delta

func enter(msg: Dictionary = {}):
	AudioManager.emit_signal("player_jumped") #Play Jump Sound
	
	if raccoon.facing == 1:
		animationPlayer.play("launch_flip")
	else:
		animationPlayer.play("launch")
	if raccoon.locked_facing == -1:
		raccoon.locked_facing = raccoon.facing

func exit():
	pass
