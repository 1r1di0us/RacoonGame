extends Area2D 
class_name player_detect_zone
#!new subclasses!
#change above to extends player_detect_zone 
#save as new script

func _on_body_entered(body):
	if not body is Raccoon: return
	#do stuff here!
