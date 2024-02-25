extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var state = 0 #0 = normal, 1 = crouched

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right") # direction = -1, 0, or 1, I think
	if direction:
		velocity.x = direction * SPEED
		$PlayerSprite.flip_h = (-direction + 1) / 2 #flip sprite in the correct direction
	else: #reduce velocity by SPEED(300) every frame until velocity is 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			$PlayerSprite.animation = "jump"
		elif Input.is_action_pressed("crouch"):
			if velocity.x == 0:
				$PlayerSprite.animation = "crouch"
			else:
				$PlayerSprite.animation = "crawl"
		else:
			if velocity.x == 0:
				$PlayerSprite.animation = "idle"
			else:
				$PlayerSprite.animation = "run"
	else: # not on floor
		# add gravity
		velocity.y += gravity * delta
		if $PlayerSprite.animation == "jump" and $PlayerSprite.frame == 5:
			$PlayerSprite.animation = "freefall"
	
	$PlayerSprite.play()
	move_and_slide()
