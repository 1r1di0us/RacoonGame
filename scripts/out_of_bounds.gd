extends player_detect_zone

func _on_body_entered(body):
	if not body is Raccoon: return
	
	AudioManager.emit_signal("player_died")
	#play game over animation
	GameManager.pause_game(1)
	
	
