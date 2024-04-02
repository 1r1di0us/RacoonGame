extends CharacterBody2D
class_name Raccoon
const SPEED = 400.0
const CRAWL_SPEED = 300.0
const JUMP_VELOCITY = -460.0 #just enough to jump over one tile
const TUCK_VELOCITY = -300.0
const HIGH_JUMP_VELOCITY_X = 150.0
const ROLL_PUSH = 300.0 # minimum roll push velocity
const LAUNCH_SPEED = 800.0
const LAUNCH_JUMP = -300.0
const CLIMB_SPEED = 300.0
const CLAMBER_SPEED = -70.0
const WALL_CLAMBER_SPEED = -70.0
const STOP_THRESHOLD = 200.0 # rolling slower than this causes you to stop rolling
const ROLL_THRESHOLD = 500.0 # FREEBALL: moving faster than this on the x allows rolling if we don't splat
const SPLAT_THRESHOLD = 1250.0 # falling faster than this splats

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

@onready var animationPlayer = $AnimationPlayer
@onready var collisionBox = $CollisionShape2D.shape

var direction = 0
var facing = 0
var prev_facing = 0
var locked_facing = -1
var climbables_count = 0
var climbable_x = 0
var clamber_x = 0
var clamber_y = 0
var climbable_walls_left_count = 0
var climbable_walls_right_count = 0
var platforms = 0
var jump_off = false
var mantle_spot: Area2D = null
var coyote_time = 0
var cant_clamber = 0
var idle_fall = 0 # for very short falls getting out of a clamber

var prevVelY = 0 #helps freeball know whether to start rolling or not

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_near_rummagable : Dictionary = {}

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
		
	if Input.is_action_pressed("move_down"):
		set_collision_mask_value(5, false)
	else:
		set_collision_mask_value(5, true)
	
	if idle_fall <+ delta:
		idle_fall = 0
	else:
		idle_fall -= delta
	if cant_clamber <= delta:
		cant_clamber = 0
	else:
		cant_clamber -= delta
	if coyote_time <= delta:
		coyote_time = 0
	else:
		coyote_time -= delta
