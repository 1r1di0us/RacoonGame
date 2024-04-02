extends Area2D

func _on_body_entered(body):
	if "climbable_walls_right_count" in body:
		var count = body.get("climbable_walls_right_count")
		body.set("climbable_walls_right_count", count + 1)
	if "climbable_x" in body:
		body.set("climbable_x", global_position.x + 16*global_scale.x) #they should all be the same


func _on_body_exited(body):
	if "climbable_walls_right_count" in body:
		var count = body.get("climbable_walls_right_count")
		body.set("climbable_walls_right_count", count - 1)
