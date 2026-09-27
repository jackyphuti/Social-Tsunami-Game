extends Control

# End Screen: Displays comprehensive performance statistics, social rank title, and replay options.

@onready var score_label: Label = $CenterContainer/Panel/VBox/ScoreLabel
@onready var high_score_label: Label = $CenterContainer/Panel/VBox/HighScoreLabel
@onready var rank_label: Label = $CenterContainer/Panel/VBox/RankLabel
@onready var stats_details_label: Label = $CenterContainer/Panel/VBox/StatsDetailsLabel
@onready var background: ColorRect = $Background

func _ready() -> void:
	display_stats()

func _get_global() -> Node:
	if has_node("/root/Global"):
		return get_node("/root/Global")
	return null

func display_stats() -> void:
	var global = _get_global()
	var stats = global.get_final_stats() if (global and global.has_method("get_final_stats")) else {}
	var hs = global.high_score if (global and "high_score" in global) else 0
	
	var score = stats.get("score", 0)
	var max_streak = stats.get("max_streak", 0)
	var waves_greeted = stats.get("waves_greeted", 0)
	var fakeouts_dodged = stats.get("fakeouts_dodged", 0)
	var is_new_record = stats.get("is_new_high_score", false)
	
	score_label.text = "FINAL SCORE: %d" % score
	
	if is_new_record:
		high_score_label.text = "🏆 NEW HIGH SCORE RECORD! 🏆"
		high_score_label.modulate = Color(1.0, 0.85, 0.2, 1.0)
	else:
		high_score_label.text = "BEST RECORD: %d" % hs
		high_score_label.modulate = Color(0.7, 0.75, 0.9, 1.0)
		
	# Determine rank title
	var rank = "SOCIAL HERMIT 🦔"
	if score >= 500:
		rank = "WAVE GOD / LEGEND ✨👑"
	elif score >= 300:
		rank = "VAPORWAVE SOCIALITE 😎"
	elif score >= 150:
		rank = "CASUAL GREETER 🙂"
	elif score >= 50:
		rank = "AWKWARD ACQUAINTANCE 😬"
		
	rank_label.text = "RANK: %s" % rank
	
	stats_details_label.text = "Waves Reciprocated: %d  •  Fake-Outs Dodged: %d\nHighest Streak: %d" % [
		waves_greeted, fakeouts_dodged, max_streak
	]

func _on_restart_pressed() -> void:
	var global = _get_global()
	if global and global.has_method("reset_stats"):
		global.reset_stats()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed() -> void:
	var global = _get_global()
	if global and global.has_method("reset_stats"):
		global.reset_stats()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
