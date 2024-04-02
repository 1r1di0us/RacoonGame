extends Area2D

@export var food_content : int = 1
var exhausted : bool = false

# is_near_rummagable : Dictionary should be a member of raccoon.gd
func _on_body_entered(body):
	if "is_near_rummagable" in body and not exhausted:
		body.set("is_near_rummagable", self)

func _on_body_exited(body):
	if "is_near_rummagable" in body:
		body.set("is_near_rummagable", null)

func rummage():
	exhausted = true
