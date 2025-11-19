extends CanvasLayer

# Pause Menu: Overlay that pauses the game and allows Resume/Quit.

func _ready() -> void:
	print("[PauseMenu] Pause menu ready")
	hide()  # Hidden by default

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if visible:
			_on_resume_pressed()
		else:
			show_pause_menu()

func show_pause_menu() -> void:
	print("[PauseMenu] Showing pause menu")
	get_tree().paused = true
	show()

func _on_resume_pressed() -> void:
	print("[PauseMenu] Resuming game")
	get_tree().paused = false
	hide()

func _on_main_menu_pressed() -> void:
	print("[PauseMenu] Returning to main menu")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
