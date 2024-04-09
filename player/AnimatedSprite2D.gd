extends AnimatedSprite2D

#Define footstep frames for each animation
var footstep_frames := {
	"walk": [1, 3],
	"run": [0, 4],
	"crawl": [0, 2, 4],
	"wall_climb": [0, 1],
	"pole_climb": [1, 3],
	"ready": [0],
	"pole_clamber": [3, 5, 7],
	"wall_clamber": [2, 5]
}

var footstep_signals := {
	"walk": "footstep_run",
	"run": "footstep_run",
	"crawl": "footstep_crawl",
	"wall_climb": "footstep_climbingwall",
	"pole_climb": "footstep_climbingpole",
	"ready": "player_launchready",
	"pole_clamber": "footstep_climbingpole",
	"wall_clamber": "footstep_climbingwall"
}

var current_animation := ""
var current_frame := 0
var FirstStep := true

func _process(delta):
	#Check if the player is moving
	if animation != "idle":
		#Check if the current frame has changed
		if frame != current_frame or animation != current_animation:
			if animation != current_animation:
				FirstStep = true
			current_frame = frame
			current_animation = animation
			#Check if the current frame is a footstep frame
			if current_animation in footstep_frames and footstep_frames[current_animation].find(current_frame) != -1:
				if current_animation == "run" and FirstStep == false:
					AudioManager.emit_signal(footstep_signals[current_animation])
				else:
					AudioManager.emit_signal(footstep_signals[current_animation])
				FirstStep = false
