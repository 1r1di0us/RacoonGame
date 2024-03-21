extends CharacterBody2D
class_name Raccoon
const SPEED = 400.0
const CRAWL_SPEED = 300.0
const JUMP_VELOCITY = -425.0
const TUCK_VELOCITY = -200.0
const HIGH_JUMP_VELOCITY_X = 150.0
const ROLL_PUSH = 300.0 # minimum roll push velocity
const LAUNCH_SPEED = 1200.0
const CLIMB_SPEED = 400.0

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

@onready var animationPlayer = $AnimationPlayer

var direction = 0
var facing = 0
var prev_facing = 0
var locked_facing = -1
var climbables_count = 0

var prevVelY = 0 #helps freeball know whether to start rolling or not

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var has_landed: bool = false

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move_left", "move_right") # direction = -1, 0, or 1, I think
	if direction != 0:
		prev_facing = facing
		facing = (-direction+1)/2 #facing is 0 or 1
	prevVelY = velocity.y
	move_and_slide()
	
	if is_on_floor() and not has_landed:
		has_landed = true
		AudioManager.emit_signal("player_landed")
	elif not is_on_floor():
		has_landed = false
