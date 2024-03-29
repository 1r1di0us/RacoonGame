extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var area2d = $Area2D

var player_on_platform : bool = false
var playerbody : CharacterBody2D = null

func _on_area_2d_body_entered(body):
	if "platforms" in body:
		var count = body.get("platforms")
		body.set("platforms", count + 1)
		
	if "clamber_x" in body:
		body.set("clamber_x", global_position.x)
	if "clamber_y" in body:
		body.set("clamber_y", global_position.y)


func _on_area_2d_body_exited(body):	
	if "platforms" in body:
		var count = body.get("platforms")
		body.set("platforms", count - 1)
