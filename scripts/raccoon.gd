extends CharacterBody2D
class_name Raccoon

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

@onready var animationPlayer = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Sounds
@onready var jump_sound: AudioStreamPlayer = $JumpSound

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right") # direction = -1, 0, or 1, I think
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = (-direction + 1) / 2 #flip sprite in the correct direction
		if direction == -1:
			$CollisionShape2D.position.x *= -1
	else: #reduce velocity by SPEED(300) every frame until velocity is 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			animationPlayer.play("jump")
			jump_sound.play();
		elif Input.is_action_pressed("crouch"):
			if velocity.x == 0:
				animationPlayer.play("crouch")
			else:
				animationPlayer.play("crawl")
		else:
			if velocity.x == 0:
				animationPlayer.play("idle")
			else:
				animationPlayer.play("run")
	else: # not on floor
		velocity.y += gravity * delta
	move_and_slide()
