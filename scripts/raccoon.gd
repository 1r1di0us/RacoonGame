extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

@onready var animationPlayer = $AnimationPlayer

var facing = false

#TODO: get AudioStreamPlayer on racoon.tscn and make jump sound work
#@onready var jump_sound: AudioStreamPlayer = $JumpSound

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right") # direction = -1, 0, or 1, I think
	if direction != 0:
		velocity.x = direction * SPEED
		facing = (-direction+1)/2 #facing is never 0
	else: #reduce velocity by SPEED(300) every frame until velocity is 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	$AnimatedSprite2D.flip_h = facing
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			animationPlayer.play("jump")
			$AnimatedSprite2D.position.y = -27
			if !facing:
				$AnimatedSprite2D.position.x = -36
			else:
				$AnimatedSprite2D.position.x = 36
			#jump_sound.play() #Play Jump Sound
		elif Input.is_action_pressed("crouch"):
			$AnimatedSprite2D.position.y = 15
			if velocity.x == 0:
				animationPlayer.play("crouch")
				if !facing:
					$AnimatedSprite2D.position.x = -33
				else:
					$AnimatedSprite2D.position.x = 33
			else:
				animationPlayer.play("crawl")
				if !facing:
					$AnimatedSprite2D.position.x = -36
				else:
					$AnimatedSprite2D.position.x = 36
		else:
			if velocity.x == 0:
				animationPlayer.play("idle")
				$AnimatedSprite2D.position.y = 0
				if !facing:
					$AnimatedSprite2D.position.x = -24
				else:
					$AnimatedSprite2D.position.x = 24
			else:
				animationPlayer.play("run")
				$AnimatedSprite2D.position.y = 0
				if !facing:
					$AnimatedSprite2D.position.x = -30
				else:
					$AnimatedSprite2D.position.x = 30
	#how to use walk animation:
	#animationPlayer.play("walk)
	#$AnimatedSprite2D.position.y = -3
	#if !facing:
	#	$AnimatedSprite2D.position.x = -36
	#else:
	#	$AnimatedSprite2D.position.x = 36
	else: # not on floor
		velocity.y += gravity * delta
		if !facing:
			$AnimatedSprite2D.position.x = -36
		else:
			$AnimatedSprite2D.position.x = 36
	move_and_slide()
	
	#var input_vector = Vector2.ZERO
	
	#input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#input_vector = input_vector.normalized ( )
	
	#$PlayerSprite.flip_h = (-direction + 1) / 2 #flip sprite in the correct direction
	#if input_vector != Vector2.ZERO:
		#animationPlayer.play( "run" )
		#velocity = velocity.move_toward( input_vector * MAX_SPEED, ACCELERATION * delta)
	#else:
		#animationPlayer.play ("idle")
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	#move_and_slide()
