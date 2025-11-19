extends Control

# End Screen: Displays final score and game statistics. Allows Restart or Main Menu.

@onready var score_label = $VBoxContainer/ScoreLabel
@onready var embarrassment_label = $VBoxContainer/EmbarrassmentLabel
@onready var social_credit_label = $VBoxContainer/SocialCreditLabel

func _ready() -> void:
	print("[EndScreen] End screen loaded")
	display_stats()

func display_stats() -> void:
	# Get game stats from a global variable or pass them via call
	if Global.has_method("get_final_stats"):
		var stats = Global.get_final_stats()
		score_label.text = "Score: %d" % stats["score"]
		embarrassment_label.text = "Embarrassment: %d%%" % stats["embarrassment"]
		social_credit_label.text = "Social Credit: %d/100" % stats["social_credit"]
	else:
		# Fallback if global not available
		print("[EndScreen] Warning: Global stats not available")
		score_label.text = "Score: 0"
		embarrassment_label.text = "Embarrassment: 0%"
		social_credit_label.text = "Social Credit: 0/100"

func _on_restart_pressed() -> void:
	print("[EndScreen] Restarting game...")
	get_tree().reload_current_scene()
	# Actually, load Main.tscn fresh
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed() -> void:
	print("[EndScreen] Returning to main menu...")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
