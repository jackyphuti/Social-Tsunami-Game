extends Node2D

# NPC Spawner: spawns NPCs at intervals in waves.

@export var npc_scene: PackedScene = preload("res://scenes/NPC.tscn")
@export var spawn_interval: float = 2.0
@export var npcs_per_wave: int = 3

var spawn_timer: float = 0.0
var npcs_spawned: int = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_npc()
		npcs_spawned += 1

func spawn_npc() -> void:
	if not npc_scene:
		return
	var npc = npc_scene.instantiate() as Node2D
	npc.position = Vector2(1200, randf_range(150, 350))
	add_child(npc)

func set_spawn_interval(value: float) -> void:
	# Public setter so other managers can change the spawn rate safely.
	spawn_interval = value

func get_spawn_interval() -> float:
	return spawn_interval
