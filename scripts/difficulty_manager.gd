extends Node

# Difficulty Manager: Dynamically scales spawn intervals and game intensity over time.

@export var spawn_interval_start: float = 2.4
@export var spawn_interval_min: float = 1.0
@export var difficulty_scale_rate: float = 0.015

var npc_spawner: Node2D = null
var elapsed_time: float = 0.0
var current_difficulty: float = 0.0

func _ready() -> void:
	if get_parent():
		npc_spawner = get_parent().get_node_or_null("NPCSpawner")

func _physics_process(delta: float) -> void:
	if not npc_spawner:
		return
		
	elapsed_time += delta
	current_difficulty = elapsed_time * difficulty_scale_rate
	
	var new_interval = max(spawn_interval_min, spawn_interval_start - current_difficulty)
	if npc_spawner.has_method("set_spawn_interval"):
		npc_spawner.set_spawn_interval(new_interval)

func get_difficulty_level() -> float:
	return current_difficulty
