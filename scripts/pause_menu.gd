extends CanvasLayer

# Pause Menu: Handles pausing, resuming, restarting, and returning to menu.
# process_mode must be set to PROCESS_MODE_ALWAYS to process input while the tree is paused.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	print("[PauseMenu] Ready")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_resume_pressed()
		else:
			show_pause_menu()
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	show()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
