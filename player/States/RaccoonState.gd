extends State
class_name RaccoonState

var raccoon: Raccoon
var animationPlayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	raccoon = owner as Raccoon
	assert(raccoon != null)
	animationPlayer = raccoon.animationPlayer
	assert(animationPlayer != null)
