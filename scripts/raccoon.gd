extends CharacterBody2D
class_name Raccoon
const SPEED = 400.0
const JUMP_VELOCITY = -720.0

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

@onready var animationPlayer = $AnimationPlayer

var facing = 0
var prev_facing = 0

#TODO: get AudioStreamPlayer on racoon.tscn and make jump sound work
#@onready var jump_sound: AudioStreamPlayer = $JumpSound

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Sounds
@onready var jump_sound: AudioStreamPlayer = $JumpSound

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right") # direction = -1, 0, or 1, I think
	if direction != 0:
		velocity.x = direction * SPEED
		prev_facing = facing
		facing = (-direction+1)/2 #facing is 0 or 1
	else: #reduce velocity by SPEED(300) every frame until velocity is 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#$AnimatedSprite2D.flip_h = facing
	if is_on_floor():
		if Input.is_action_just_pressed("jump") && !Input.is_action_pressed("crouch"): #can't jump while crouching
			velocity.y = JUMP_VELOCITY
			#animationPlayer.play("jump")
			#$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -160
			if !facing:
				animationPlayer.play("jump")
			#	$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
			else:
				animationPlayer.play("jump_flip")
			#	$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
			jump_sound.play() #Play Jump Sound
		elif Input.is_action_pressed("crouch"):
			$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -80
			if velocity.x == 0:
				animationPlayer.play("crouch")
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
			else:
				animationPlayer.play("crawl")
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
		else:
			if velocity.x == 0:
				animationPlayer.play("idle")
				$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -110
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -40
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 40
			else:
				animationPlayer.play("run")
				$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -110
				if !facing:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -50
				else:
					$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 50
	#how to use walk animation:
	#animationPlayer.play("walk)
	#$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -110
	#if !facing:
	#	$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
	#else:
	#	$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
	else: # not on floor
		velocity.y += gravity * delta
		#$AnimatedSprite2D.position.y = $AnimatedSprite2D.scale.y * -160
		#if !facing:
		#	$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * -60
		#else:
		#	$AnimatedSprite2D.position.x = $AnimatedSprite2D.scale.x * 60
		if Input.is_action_just_released("jump") && velocity.y < 0:
			velocity.y = 0
		
		if animationPlayer.current_animation == "jump" && animationPlayer.current_animation_position == 6:
			animationPlayer.play("freefall")
		elif animationPlayer.current_animation == "jump_flip" && animationPlayer.current_animation_position == 6:
			animationPlayer.play("freefall_flip")
		
		if prev_facing != facing:
			if animationPlayer.current_animation == "jump" || animationPlayer.current_animation == "jump_flip":
				var temp = animationPlayer.current_animation_position
				if facing:
					animationPlayer.play("jump_flip", temp)
				else:
					animationPlayer.play("jump", temp)
			elif animationPlayer.current_animation == "freefall" || animationPlayer.current_animation == "freefall_flip":
				var temp = animationPlayer.current_animation_position
				if facing:
					animationPlayer.play("freefall_flip", temp)
				else:
					animationPlayer.play("freefall", temp)
	move_and_slide()
