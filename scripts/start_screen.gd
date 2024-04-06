extends CanvasLayer

func _on_start_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_exit_button_pressed():
	GameManager.exit_game()

func _on_level_select_button_pressed():
	GameManager.transition_to_scene("res://ui/level_select_screen.tscn")
