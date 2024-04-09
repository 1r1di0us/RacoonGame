extends AnimatedSprite2D

#Define footstep frames for each animation
var footstep_frames := {
	"walk": [1, 3],
	"run": [0, 4],
	"crawl": [0, 2, 4]
}

var current_animation := ""
var current_frame := 0

func _process(delta):
	#Check if the player is moving
	if animation != "idle":
		#Check if the current frame has changed
		if frame != current_frame or animation != current_animation:
			current_frame = frame
			current_animation = animation
			#Check if the current frame is a footstep frame
			if current_animation in footstep_frames and footstep_frames[current_animation].find(current_frame) != -1:
				#Play footstep sound
				AudioManager.emit_signal("footstep_walk")
