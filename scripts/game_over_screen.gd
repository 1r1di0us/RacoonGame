extends CanvasLayer

#var thisLevel

func _on_retry_button_pressed():
	GameManager.pause_game(1)
	AudioManager.emit_signal("PlayerDeadSetFalse")
	GameManager.transition_to_scene("res://levels/level_"+str(GameManager.current_level)+".tscn")
	queue_free()

func _on_main_menu_button_pressed():
	GameManager.main_menu()
	AudioManager.emit_signal("PlayerDeadSetFalse")
	queue_free()
