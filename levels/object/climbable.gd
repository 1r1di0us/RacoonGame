extends Area2D
# climbables_count : int should be made a member of raccoon.gd 
func _on_body_entered(body):
	if "climbables_count" in body:
		var count = body.get("climbables_count")
		body.set("climbables_count", count + 1)
	if "climbable_x" in body:
		body.set("climbable_x", global_position.x)#they should all be the same


func _on_body_exited(body):
	if "climbables_count" in body:
		var count = body.get("climbables_count")
		body.set("climbables_count", count - 1)
