extends Area2D
# climbables_count : int should be made a member of raccoon.gd 
func _on_body_entered(body):
	if "climbables_count" in body:
		var count = body.get("climbables_count")
		body.set("climbables_count", count + 1)


func _on_body_exited(body):
	if "climbables_count" in body:
		var count = body.get("climbables_count")
		body.set("climbables_count", count - 1)
