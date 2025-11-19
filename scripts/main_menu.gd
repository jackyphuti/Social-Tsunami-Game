extends Control

# Main Menu: Entry point for the game. Shows Start/Quit buttons.

func _ready() -> void:
	print("[MainMenu] Menu loaded")

func _on_start_pressed() -> void:
	print("[MainMenu] Starting game...")
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_quit_pressed() -> void:
	print("[MainMenu] Quitting game...")
	get_tree().quit()
