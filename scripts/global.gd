extends Node

# Global: Autoload singleton for storing game state, high scores, and audio settings across scenes.

const SAVE_PATH := "user://social_tsunami_save.json"

var high_score: int = 0
var max_streak_record: int = 0
var total_games_played: int = 0

var final_stats: Dictionary = {
	"score": 0,
	"embarrassment": 0.0,
	"social_credit": 100.0,
	"max_streak": 0,
	"waves_greeted": 0,
	"fakeouts_dodged": 0,
	"is_new_high_score": false
}

func _ready() -> void:
	load_save_data()

func set_final_stats(stats: Dictionary) -> void:
	final_stats = stats
	total_games_played += 1
	var current_score = stats.get("score", 0)
	var current_streak = stats.get("max_streak", 0)
	
	if current_score > high_score:
		high_score = current_score
		final_stats["is_new_high_score"] = true
	else:
		final_stats["is_new_high_score"] = false
		
	if current_streak > max_streak_record:
		max_streak_record = current_streak
		
	save_data()
	print("[Global] Final stats saved: %s, High Score: %d" % [final_stats, high_score])

func get_final_stats() -> Dictionary:
	return final_stats

func reset_stats() -> void:
	final_stats = {
		"score": 0,
		"embarrassment": 0.0,
		"social_credit": 100.0,
		"max_streak": 0,
		"waves_greeted": 0,
		"fakeouts_dodged": 0,
		"is_new_high_score": false
	}
	print("[Global] Stats reset")

func save_data() -> void:
	var data = {
		"high_score": high_score,
		"max_streak_record": max_streak_record,
		"total_games_played": total_games_played
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_save_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(text)
		if parsed is Dictionary:
			high_score = int(parsed.get("high_score", 0))
			max_streak_record = int(parsed.get("max_streak_record", 0))
			total_games_played = int(parsed.get("total_games_played", 0))
			print("[Global] Save loaded. High score: %d" % high_score)
