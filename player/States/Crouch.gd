extends RaccoonState
class_name Crouch

var charge_timer: float = 0
var launch_ready: int = 0

func physics_update(delta: float):
	if launch_ready == 1:
		if raccoon.facing == 1:
			animationPlayer.play("ready_flip")
		else:
			animationPlayer.play("ready")
		if Input.is_action_just_released("jump"):
			raccoon.velocity.x = (-raccoon.facing*2 + 1) * raccoon.LAUNCH_SPEED
			raccoon.velocity.y = raccoon.LAUNCH_JUMP
			raccoon.locked_facing = raccoon.facing
			launch_ready = 0
			finished.emit("Launch")
	else:
		if (Input.is_action_pressed("move_up") && raccoon.climbables_count >= 1
			&& raccoon.global_position.x >= raccoon.climbable_x - 32
			&& raccoon.global_position.x <= raccoon.climbable_x + 32):
			finished.emit("Pole_Climb")
		elif not raccoon.is_on_floor() && raccoon.idle_fall == 0:
			raccoon.cant_clamber = 0.25
			raccoon.coyote_time = 0.1
			finished.emit("Freefall")
		elif Input.is_action_just_pressed("jump") && charge_timer == 0 && (Input.is_action_pressed("crouch") || raccoon.platforms > 0):
			charge_timer = 0.5;
		elif Input.is_action_pressed("jump") && charge_timer > 0:
			if raccoon.facing == 1:
				animationPlayer.play("crouch_flip")
			else:
				animationPlayer.play("crouch")
			charge_timer -= delta # decrement timer
			if charge_timer <= 0:
				charge_timer = 0
				#finished.emit("Ready") #when we get a ready animation
				launch_ready = 1
		#elif raccoon.is_near_rummagable != {} && Input.is_action_just_pressed("interact"):
		#	finished.emit("Rummage")
		elif not Input.is_action_pressed("crouch") && charge_timer <= 0 && raccoon.platforms <= 0 && raccoon.idle_fall == 0:
			finished.emit("Idle")
		elif not raccoon.direction == 0 && charge_timer <= 0:
			finished.emit("Crawl")
		else:
			if Input.is_action_just_released("jump") && charge_timer > 0:
				charge_timer = 0
			raccoon.velocity.y += raccoon.gravity * delta
			if raccoon.velocity.x != 0:
				raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("crouch_flip")
	else:
		animationPlayer.play("crouch")

func exit():
	charge_timer = 0
	launch_ready = 0
