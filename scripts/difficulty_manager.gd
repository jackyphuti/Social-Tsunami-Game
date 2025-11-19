extends Node

# Difficulty Manager: scales game difficulty over time (more NPCs, faster spawns).

@export var spawn_interval_start: float = 2.0
@export var spawn_interval_min: float = 0.8
@export var difficulty_scale_rate: float = 0.02  # Decrease spawn interval by 2% every second

var npc_spawner: Node = null
var elapsed_time: float = 0.0
var current_difficulty: float = 0.0
var _last_difficulty_print: int = -1

func _ready() -> void:
	if get_parent().has_node("NPCSpawner"):
		npc_spawner = get_parent().get_node("NPCSpawner")

func _physics_process(delta: float) -> void:
	if not npc_spawner:
		return
	
	elapsed_time += delta
	current_difficulty = elapsed_time * difficulty_scale_rate
	
	# Calculate new spawn interval (decreases over time)
	var new_interval = max(spawn_interval_min, spawn_interval_start - current_difficulty)
	# Prefer using a setter on the spawner if present; fall back to property assignment with a type check.
	if npc_spawner.has_method("set_spawn_interval"):
		npc_spawner.call("set_spawn_interval", new_interval)
	else:
		# Ensure we don't try to assign arbitrary properties on plain Node2D
		if "spawn_interval" in npc_spawner:
			npc_spawner.spawn_interval = new_interval
		else:
			# Last resort: if the spawner is a Node2D without the property, print a warning once.
			if not npc_spawner.has_meta("warned_spawn_interval_missing"):
				npc_spawner.set_meta("warned_spawn_interval_missing", true)
				push_warning("NPCSpawner node does not expose 'spawn_interval' or setter; difficulty scaling skipped.")
	
	# Print difficulty update once every 10 seconds (avoid spamming the console)
	var elapsed_sec = int(elapsed_time)
	if elapsed_sec % 10 == 0 and _last_difficulty_print != elapsed_sec:
		_last_difficulty_print = elapsed_sec
		print("Difficulty increased: spawn interval = %.2f sec (difficulty level: %.2f)" % [new_interval, current_difficulty])

func get_difficulty_level() -> float:
	return current_difficulty
