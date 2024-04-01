extends Area2D

var mantle_direction_left : bool = false

func _on_body_entered(body):
	if "mantle_spot" in body:
		body.set("mantle_spot", self)


func _on_body_exited(body):
	if "mantle_spot" in body:
		body.set("mantle_spot", null)
