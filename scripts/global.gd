extends Node

# Global: Singleton for storing game state across scenes.

var final_stats: Dictionary = {
	"score": 0,
	"embarrassment": 0.0,
	"social_credit": 100.0
}

func set_final_stats(stats: Dictionary) -> void:
	final_stats = stats
	print("[Global] Final stats saved: %s" % stats)

func get_final_stats() -> Dictionary:
	return final_stats

func reset_stats() -> void:
	final_stats = {
		"score": 0,
		"embarrassment": 0.0,
		"social_credit": 100.0
	}
	print("[Global] Stats reset")
