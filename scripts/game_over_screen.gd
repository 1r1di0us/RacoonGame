extends CanvasLayer

#var thisLevel

func _on_retry_button_pressed():
	GameManager.pause_game(1)
	AudioManager.emit_signal("PlayerDeadSetFalse")
	GameManager.transition_to_scene("res://levels/level_"+str(GameManager.current_level)+".tscn")
	GameManager.level_score[GameManager.current_level-1] = 0
	queue_free()

func _on_main_menu_button_pressed():
	GameManager.main_menu()
	AudioManager.emit_signal("PlayerDeadSetFalse")
	queue_free()
