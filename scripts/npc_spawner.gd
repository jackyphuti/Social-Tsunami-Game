extends Node2D

# NPC Spawner: Spawns NPCs at dynamic intervals at the right side of the screen.

signal npc_spawned(npc: Node2D)

@export var npc_scene: PackedScene = preload("res://scenes/NPC.tscn")
@export var base_spawn_interval: float = 2.4

var current_spawn_interval: float = 2.4
var spawn_timer: float = 0.0
var npcs_spawned_count: int = 0
var is_active: bool = true

func _ready() -> void:
	current_spawn_interval = base_spawn_interval
	# Spawn first NPC after a brief grace period (1.5 seconds)
	spawn_timer = current_spawn_interval - 1.5

func _physics_process(delta: float) -> void:
	if not is_active:
		return
		
	spawn_timer += delta
	if spawn_timer >= current_spawn_interval:
		spawn_timer = 0.0
		spawn_npc()

func spawn_npc() -> Node2D:
	if not npc_scene:
		return null
		
	var npc = npc_scene.instantiate() as Node2D
	# Spawn at ground level off the right edge of 1280x720 screen
	npc.position = Vector2(1380.0, 440.0)
	add_child(npc)
	npcs_spawned_count += 1
	npc_spawned.emit(npc)
	return npc

func set_spawn_interval(value: float) -> void:
	current_spawn_interval = max(0.9, value)

func get_spawn_interval() -> float:
	return current_spawn_interval

func stop_spawning() -> void:
	is_active = false
