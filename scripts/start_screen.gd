extends CanvasLayer
var hover_sound: AudioStreamPlayer

func _on_hover_sound_ready():
	hover_sound = $HoverSound

func _on_start_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_exit_button_pressed():
	GameManager.exit_game()



func _on_start_button_mouse_entered():
	play_hover_sound()

func _on_exit_button_mouse_entered():
	play_hover_sound()

func play_hover_sound():
	if hover_sound and not hover_sound.playing:
		hover_sound.play()

