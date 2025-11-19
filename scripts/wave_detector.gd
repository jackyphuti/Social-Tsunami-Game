extends Node2D

# Wave Detector: listens to NPC signals and checks if player waves correctly.
# Improved with directional bias (requires upward hand motion).

@export var wave_detection_threshold: float = 0.5
@export var upward_bias_required: bool = true

var player: Node2D = null
var current_npc: Node2D = null
var player_waved: bool = false
var wave_window_open: bool = false
var hand_position_start: Vector2 = Vector2.ZERO
var ui_manager: Node = null

signal wave_detected(is_correct: bool, npc: Node2D)

func _ready() -> void:
	# Get player reference
	if get_parent().has_node("Player"):
		player = get_parent().get_node("Player")
	
	# Get UI manager reference
	if get_parent().has_node("UICanvas"):
		ui_manager = get_parent().get_node("UICanvas")
	
	# Connect to NPCs as they spawn
	if get_parent().has_node("NPCSpawner"):
		var spawner = get_parent().get_node("NPCSpawner")
		spawner.child_entered_tree.connect(_on_npc_spawned)

func _on_npc_spawned(node: Node) -> void:
	# Connect to NPC signals
	if node.has_signal("on_wave_start") and node.has_signal("on_wave_end"):
		node.on_wave_start.connect(_on_npc_wave_start.bindv([node]))
		node.on_wave_end.connect(_on_npc_wave_end.bindv([node]))

func _on_npc_wave_start(is_fake_out: bool, npc: Node2D) -> void:
	current_npc = npc
	wave_window_open = true
	player_waved = false
	if player and player.has_node("Arm/Hand"):
		hand_position_start = player.get_node("Arm/Hand").global_position

func _on_npc_wave_end(npc: Node2D) -> void:
	if current_npc == npc:
		wave_window_open = false
		
		# Determine if the wave was correct
		var player_did_wave = player_waved
		var npc_is_fake = npc.get_is_fake_out()
		
		# Real wave: player should have waved
		# Fake-out: player should NOT have waved
		var is_correct = (not npc_is_fake and player_did_wave) or (npc_is_fake and not player_did_wave)
		
		wave_detected.emit(is_correct, npc)
		
		# Show feedback in UI
		if ui_manager:
			if is_correct:
				ui_manager.show_wave_feedback("✓ Correct!", Color.GREEN, 1.0)
			else:
				ui_manager.show_wave_feedback("✗ Wrong!", Color.RED, 1.0)
		
		current_npc = null

func check_player_waved() -> bool:
	# Improved heuristic: check if hand moved significantly with upward bias
	if not player or not player.has_node("Arm/Hand"):
		return false
	
	var hand = player.get_node("Arm/Hand")
	var velocity = hand.linear_velocity
	var total_velocity = velocity.length()
	
	# Check if velocity exceeds threshold
	if total_velocity < wave_detection_threshold:
		return false
	
	# If upward bias is required, check if hand is moving upward
	if upward_bias_required:
		# Upward = negative Y (Godot coordinate system)
		return velocity.y < -0.2  # Significant upward component
	
	return true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if wave_window_open:
			if check_player_waved():
				player_waved = true
