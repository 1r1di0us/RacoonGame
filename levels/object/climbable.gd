extends Area2D

func _on_body_entered(body):
	if "climbables_count" in body:
		var count = body.get("climbables_count")
		body.set("climbables_count", count + 1)


func _on_body_exited(body):
	if "climbables_count" in body:
		var count = body.get("climbables_count")
		body.set("climbables_count", count - 1)
