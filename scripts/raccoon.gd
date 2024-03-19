extends CharacterBody2D
class_name Raccoon
const SPEED = 400.0
const CRAWL_SPEED = 300.0
const JUMP_VELOCITY = -425.0
const HIGH_JUMP_VELOCITY_X = 150.0
const ROLL_PUSH = 5
const LAUNCH_SPEED = 1000.0

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

@onready var animationPlayer = $AnimationPlayer

var direction = 0
var facing = 0
var prev_facing = 0
var locked_dir = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var raycast1: RayCast2D
var raycast2: RayCast2D

# Sounds
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var jump_landing_sound: AudioStreamPlayer = $JumpLandingSound

func _ready():
	raycast1 = $RayCastLandingDetection1
	raycast2 = $RayCastLandingDetection2

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move_left", "move_right") # direction = -1, 0, or 1, I think
	if direction != 0:
		prev_facing = facing
		facing = (-direction+1)/2 #facing is 0 or 1
	move_and_slide()
