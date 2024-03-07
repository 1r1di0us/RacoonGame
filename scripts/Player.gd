extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var can_jump = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 1500

# Sounds
@onready var jump_sound: AudioStreamPlayer = $JumpSound

func _physics_process(delta):
	
	#TODO: replace stupid PlayerSprite with AnimationPlayer and figure out how that solves the crisis
	#around the collision shapes and changing their sizes, because apparently its the solution
	# https://www.reddit.com/r/godot/comments/11ps5nr/what_is_the_correct_way_to_change_the_collision/
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right") # direction = -1, 0, or 1, I think
	if direction:
		velocity.x = direction * SPEED
		$PlayerSprite.flip_h = (-direction + 1) / 2 #flip sprite in the correct direction
	else: #reduce velocity by SPEED(300) every frame until velocity is 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			$PlayerCollision.shape.extents = Vector2(37, 48)
			$PlayerSprite.animation = "jump"
			jump_sound.play() #Play Jump Sound
		elif Input.is_action_pressed("crouch"):
			$PlayerCollision.shape.extents = Vector2(42, 24)
			if velocity.x == 0:
				$PlayerSprite.animation = "crouch"
			else:
				$PlayerSprite.animation = "crawl"
		else:
			if velocity.x == 0:
				$PlayerCollision.shape.extents = Vector2(24, 33)
				$PlayerSprite.animation = "idle"
			else:
				$PlayerCollision.shape.size = Vector2(42, 33)
				$PlayerSprite.animation = "run"
	else: # not on floor
		# add gravity
		#$PlayerCollision.shape.extents = Vector2(37, 48)
		#$PlayerCollision.transform.position = Vector2(37, 48)
		velocity.y += gravity * delta
		#if $PlayerSprite.animation == "jump" and $PlayerSprite.frame == 5:
			#$PlayerSprite.animation = "freefall"
	
	$PlayerSprite.play()
	move_and_slide()
