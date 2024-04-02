extends Area2D

@export var food_content : int = 0
@export var full_sprite : Texture2D
@export var empty_sprite : Texture2D


var exhausted : bool = false
signal rummaged

func _ready():
	$EmptySprite.texture = empty_sprite
	$FullSprite.texture = full_sprite

# is_near_rummagable : Dictionary should be a member of raccoon.gd
func _on_body_entered(body):
	if "is_near_rummagable" in body and not exhausted:
		body.set("is_near_rummagable", {"spot": self, "value": food_content})

func _on_body_exited(body):
	if "is_near_rummagable" in body:
		body.set("is_near_rummagable", {})

func rummage():
	exhausted = true
	$FullSprite.hide()
	GameManager.add_score(food_content);
	print("object: rummaging")
