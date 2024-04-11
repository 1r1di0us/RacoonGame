extends player_detect_zone

@export() var level_instructions = ""
@export_enum("rummage", "wall_climb", "jump", "pole_climb", "roll", "roll_jump") var animation


func _ready():
	$TutorialInstructions.text = level_instructions#
	visible = false
	
	

func _on_body_entered(body):
	if not body is Raccoon: return
	visible = true
	play_animation(animation)

func _on_body_exited(body):
	visible = false
	

func play_animation(anim):
	match(anim):
		0:#rummage
			$AnimationPlayer.play("rummage")
		1:#wall_climb
			$AnimationPlayer.play("wall_climb")
		2:#jump
			$AnimationPlayer.play("jump")
			await get_tree().create_timer(0.3).timeout
			$AnimationPlayer.play("roll")
			await get_tree().create_timer(0.4).timeout
			$AnimationPlayer.play("idle")
			$AnimationPlayer.stop()
		3:#pole_climb
			$AnimationPlayer.play("pole_climb")
		4:#roll
			$AnimationPlayer.play("crouch")
			await get_tree().create_timer(1).timeout
			$AnimationPlayer.play("ready")
			await get_tree().create_timer(0.5).timeout
			$AnimationPlayer.play("launch")
			await get_tree().create_timer(0.4).timeout
			$AnimationPlayer.play("roll")
		5:#roll_jump
			$AnimationPlayer.play("crouch")
			await get_tree().create_timer(1).timeout
			$AnimationPlayer.play("ready")
			await get_tree().create_timer(0.5).timeout
			$AnimationPlayer.play("launch")
			await get_tree().create_timer(0.4).timeout
			$AnimationPlayer.play("roll")
			await get_tree().create_timer(1).timeout
			$AnimationPlayer.play("jump")
			await get_tree().create_timer(0.5).timeout
			$AnimationPlayer.play("idle")
			$AnimationPlayer.stop()

