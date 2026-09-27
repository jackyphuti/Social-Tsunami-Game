extends Node

# Wave Detector: Monitors hand velocity, height, and oscillation to recognize player waving.
# Triggers resolution on active NPCs in the interaction zone.

signal player_performed_wave(pos: Vector2)

@export var wave_vel_threshold: float = 200.0
@export var wave_cooldown: float = 0.25

var player: Node2D = null
var npc_spawner: Node2D = null
var game_manager: Node = null

var wave_timer: float = 0.0
var prev_vel_x: float = 0.0
var direction_changes: int = 0
var oscillation_window: float = 0.0

func _ready() -> void:
	if get_parent():
		player = get_parent().get_node_or_null("Player")
		npc_spawner = get_parent().get_node_or_null("NPCSpawner")
		game_manager = get_parent()

func _physics_process(delta: float) -> void:
	if not player:
		return
		
	wave_timer += delta
	oscillation_window += delta
	
	if oscillation_window > 0.6:
		oscillation_window = 0.0
		direction_changes = 0
		
	if not player.has_method("get_hand_velocity"):
		return
		
	var is_dragging = player.is_dragging() if player.has_method("is_dragging") else false
	if not is_dragging:
		return
		
	var hand_vel = player.get_hand_velocity()
	var hand_pos = player.get_hand_global_pos()
	var shoulder_y = player.global_position.y - 20.0
	
	# Check if hand is raised (above waist level)
	var is_hand_raised = hand_pos.y < (shoulder_y + 60.0)
	var total_speed = hand_vel.length()
	
	# Detect side-to-side oscillation
	if prev_vel_x * hand_vel.x < -1000.0: # Reversal with speed
		direction_changes += 1
		
	prev_vel_x = hand_vel.x
	
	# Condition to qualify as a wave gesture:
	# 1. Hand raised
	# 2. Significant speed (flinging or shaking) OR back-and-forth oscillation
	var is_waving = is_hand_raised and (total_speed > wave_vel_threshold or direction_changes >= 1)
	
	if is_waving and wave_timer >= wave_cooldown:
		wave_timer = 0.0
		direction_changes = 0
		_on_wave_action(hand_pos)

func _on_wave_action(hand_pos: Vector2) -> void:
	player_performed_wave.emit(hand_pos)
	
	# Find active NPC in interaction zone (closest to player)
	var target_npc: Node2D = _get_closest_active_npc()
	if target_npc and target_npc.has_method("player_waved_at_me"):
		target_npc.player_waved_at_me()

func _get_closest_active_npc() -> Node2D:
	if not npc_spawner:
		return null
		
	var best_npc: Node2D = null
	var min_dist: float = 99999.0
	var player_x = player.global_position.x if player else 260.0
	
	for child in npc_spawner.get_children():
		if child.get("is_active_interaction") == true and not child.get("has_resolved"):
			var dist = abs(child.global_position.x - player_x)
			if dist < min_dist:
				min_dist = dist
				best_npc = child
				
	return best_npc
