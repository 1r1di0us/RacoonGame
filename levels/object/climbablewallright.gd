extends Area2D

func _on_body_entered(body):
	if "climbable_walls_right_count" in body:
		var count = body.get("climbable_walls_right_count")
		body.set("climbable_walls_right_count", count + 1)


func _on_body_exited(body):
	if "climbable_walls_right_count" in body:
		var count = body.get("climbable_walls_right_count")
		body.set("climbable_walls_right_count", count - 1)
