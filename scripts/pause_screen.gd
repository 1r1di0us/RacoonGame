extends CanvasLayer

func _on_resume_button_pressed():
	GameManager.pause_game(0)
	queue_free()
	#hide()
	#get_tree().paused = false

func _on_main_menu_button_pressed():
	GameManager.main_menu()
	queue_free()
