extends Control

# Main Menu: Title screen with High Score, How-To-Play modal, and game start.

@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var how_to_play_modal: PanelContainer = $HowToPlayModal

func _ready() -> void:
	var global = _get_global()
	var hs = global.high_score if (global and "high_score" in global) else 0
	if high_score_label:
		if hs > 0:
			high_score_label.text = "🏆 ALL-TIME HIGH SCORE: %d" % hs
			high_score_label.visible = true
		else:
			high_score_label.visible = false
			
	if how_to_play_modal:
		how_to_play_modal.visible = false

func _get_global() -> Node:
	if has_node("/root/Global"):
		return get_node("/root/Global")
	return null

func _on_start_pressed() -> void:
	var global = _get_global()
	if global and global.has_method("reset_stats"):
		global.reset_stats()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_how_to_play_pressed() -> void:
	if how_to_play_modal:
		how_to_play_modal.visible = true

func _on_close_tutorial_pressed() -> void:
	if how_to_play_modal:
		how_to_play_modal.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
