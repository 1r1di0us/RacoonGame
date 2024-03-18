extends CharacterBody2D
class_name Raccoon
const SPEED = 400.0
const CRAWL_SPEED = 300.0
const JUMP_VELOCITY = -520.0

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
		if is_on_floor && Input.is_action_pressed("crouch"):
			velocity.x = direction * CRAWL_SPEED
		else:
			velocity.x = direction * SPEED
		prev_facing = facing
		facing = (-direction+1)/2 #facing is 0 or 1
	else: #reduce velocity by SPEED every frame until velocity is 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#$AnimatedSprite2D.flip_h = facing
	if is_on_floor():
		if Input.is_action_just_pressed("jump") && !Input.is_action_pressed("crouch"): #can't jump while crouching
			velocity.y = JUMP_VELOCITY
			if facing:
				animationPlayer.play("jump_flip")
			else:
				animationPlayer.play("jump")
			jump_sound.play() #Play Jump Sound
		elif Input.is_action_pressed("crouch"):
			if velocity.x == 0:
				if facing:
					animationPlayer.play("crouch_flip")
				else:
					animationPlayer.play("crouch")
					#no flipping while staying still
			else:
				if facing:
					animationPlayer.play("crawl_flip")
				else:
					animationPlayer.play("crawl")
				
				if prev_facing != facing: # we want to flip
					var temp = animationPlayer.current_animation_position
					if facing:
						animationPlayer.play("crawl_flip")
					else:
						animationPlayer.play("crawl")
					animationPlayer.seek(temp, true)
		else:
			if velocity.x == 0:
				if facing:
					animationPlayer.play("idle_flip")
				else:
					animationPlayer.play("idle")
			else:
				if facing:
					animationPlayer.play("run_flip")
				else:
					animationPlayer.play("run")
				
				if prev_facing != facing: # we want to flip
					var temp = animationPlayer.current_animation_position
					if facing:
						animationPlayer.play("run_flip")
					else:
						animationPlayer.play("run")
					animationPlayer.seek(temp, true)
	
	else: # not on floor
		velocity.y += gravity * delta
		if Input.is_action_just_released("jump") && velocity.y < 0:
			velocity.y = 0
			animationPlayer.seek(0.4, true)
		
		if animationPlayer.current_animation == "jump" && animationPlayer.current_animation_position >= 0.6:
			animationPlayer.play("freefall")
		elif animationPlayer.current_animation == "jump_flip" && animationPlayer.current_animation_position >= 0.6:
			animationPlayer.play("freefall_flip")
		
		if prev_facing != facing:
			var temp = animationPlayer.current_animation_position
			if animationPlayer.current_animation == "jump" || animationPlayer.current_animation == "jump_flip":
				if facing:
					animationPlayer.play("jump_flip")
				else:
					animationPlayer.play("jump")
			elif animationPlayer.current_animation == "freefall" || animationPlayer.current_animation == "freefall_flip":
				if facing:
					animationPlayer.play("freefall_flip")
				else:
					animationPlayer.play("freefall")
			animationPlayer.seek(temp, true)
	move_and_slide()
