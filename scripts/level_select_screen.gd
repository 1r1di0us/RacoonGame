extends CanvasLayer

func _on_back_button_pressed():
	GameManager.main_menu()
	queue_free()

func _ready():
	if(GameManager.isLevelDone(1)):
		$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LevelOneButton.visible = true
	if(GameManager.isLevelDone(2)):
		$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LevelTwoButton.visible = true
	if(GameManager.isLevelDone(3)):
		$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LeveThreeButton.visible = true
