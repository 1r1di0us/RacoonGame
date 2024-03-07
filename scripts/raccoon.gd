extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -520.0

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

@onready var animationPlayer = $AnimationPlayer

var facing = false
var stored_jump = false

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
		if Input.is_action_pressed("jump") && stored_jump: #pressing and holding jump again while falling 
			stored_jump = false
			velocity.y = JUMP_VELOCITY
			animationPlayer.play("jump")
			$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -45
			if !facing:
				$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
			else:
				$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
		elif Input.is_action_just_pressed("jump") && !Input.is_action_pressed("crouch"): #can't jump while crouching
			velocity.y = JUMP_VELOCITY
			animationPlayer.play("jump")
			$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -45
			if !facing:
				$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
			else:
				$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
			#jump_sound.play() #Play Jump Sound
		elif Input.is_action_pressed("crouch"):
			$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * 25
			if velocity.x == 0:
				animationPlayer.play("crouch")
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -55
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 55
			else:
				animationPlayer.play("crawl")
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
		else:
			if velocity.x == 0:
				animationPlayer.play("idle")
				$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * 0 #consistency is key
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -40
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 40
			else:
				animationPlayer.play("run")
				$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * 0
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -50
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 50
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
			$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
		else:
			$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
		if Input.is_action_just_released("jump") && velocity.y < 0:
			velocity.y = 0
		if Input.is_action_just_pressed("jump"): #pressing jump again mid-air. will only jump if you hold it
			stored_jump = true
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
