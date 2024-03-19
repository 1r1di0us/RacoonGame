extends RaccoonState
class_name Crouch

var charge_timer: float = 0
var launch_ready: int = 0

func physics_update(delta: float):
	if launch_ready == 1:
		if raccoon.facing == 1:
			animationPlayer.play("crouch_flip")
		else:
			animationPlayer.play("crouch")
		
		if Input.is_action_just_released("jump"):
			raccoon.velocity.x = (-raccoon.facing*2 + 1) * raccoon.LAUNCH_SPEED
			finished.emit("Roll")
	else:
		if not raccoon.is_on_floor:
			finished.emit("Freefall")
		elif Input.is_action_just_pressed("jump") && not Input.is_action_pressed("crouch"):
			finished.emit("Jump")
		elif Input.is_action_just_pressed("jump") && Input.is_action_pressed("crouch"):
			charge_timer = 0.5;
		elif Input.is_action_pressed("jump") && Input.is_action_pressed("crouch"):
			charge_timer -= delta
			if charge_timer <= 0:
				charge_timer = 0
				#finished.emit("Ready") #when we get a ready animation
				launch_ready = 1
		elif not Input.is_action_pressed("crouch"):
			finished.emit("Idle")
		elif not raccoon.direction == 0:
			finished.emit("Crawl")
			
	raccoon.velocity.y += raccoon.gravity * delta
	if raccoon.velocity.x != 0:
		raccoon.velocity.x = move_toward(raccoon.velocity.x, 0, raccoon.ACCELERATION)

func enter(msg: Dictionary = {}):
	if raccoon.facing == 1:
		animationPlayer.play("crouch_flip")
	else:
		animationPlayer.play("crouch")

func exit():
	pass
