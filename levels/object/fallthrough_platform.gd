extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var area2d = $Area2D

var player_on_platform : bool = false
var playerbody : CharacterBody2D = null

func _unhandled_input(event):
	if event.is_action_pressed("crouch"):
		if player_on_platform == true and playerbody != null:
			playerbody.set_collision_mask_value(5, false)
	if event.is_action_released("crouch") and playerbody != null:
		playerbody.set_collision_mask_value(5, true)

func _on_area_2d_body_entered(body):
	player_on_platform = true
	playerbody = body


func _on_area_2d_body_exited(body):
	player_on_platform = false
	playerbody.set_collision_mask_value(5, true)
	playerbody = null
