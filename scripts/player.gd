extends Node2D

# Player: Controls the springy ragdoll arm, walking animation bob, and visual aesthetics.

@export var spring_strength: float = 38.0
@export var damping: float = 8.5
@export var max_reach: float = 240.0

var hand: RigidBody2D = null
var forearm: RigidBody2D = null
var upper_arm: RigidBody2D = null
var shoulder: StaticBody2D = null

var dragging: bool = false
var walk_time: float = 0.0
var base_body_pos: Vector2 = Vector2.ZERO

@onready var body_visual: Node2D = $BodyVisual if has_node("BodyVisual") else null
@onready var head_visual: Node2D = $BodyVisual/Head if has_node("BodyVisual/Head") else null

func _ready() -> void:
	hand = get_node_or_null("Arm/Hand") as RigidBody2D
	forearm = get_node_or_null("Arm/Forearm") as RigidBody2D
	upper_arm = get_node_or_null("Arm/UpperArm") as RigidBody2D
	shoulder = get_node_or_null("Arm/Shoulder") as StaticBody2D
	
	if body_visual:
		base_body_pos = body_visual.position
		
	# Configure rigid bodies for responsive ragdoll waving
	for part in [upper_arm, forearm, hand]:
		if part:
			part.linear_damp = 3.0
			part.angular_damp = 4.0
			part.can_sleep = false
			part.collision_layer = 2
			part.collision_mask = 0  # Do not collide with world or each other

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed

func _physics_process(delta: float) -> void:
	walk_time += delta * 6.5
	
	# 1. Rhythmic walking bob for body and head
	if body_visual:
		var bob = sin(walk_time) * 4.0
		var tilt = sin(walk_time * 0.5) * 0.03
		body_visual.position = base_body_pos + Vector2(0, bob)
		body_visual.rotation = tilt
	
	# 2. Arm physics controller: springy mouse pull with reach limit
	if hand and shoulder:
		if dragging:
			var mouse_pos = get_global_mouse_position()
			var shoulder_pos = shoulder.global_position
			var from_shoulder = mouse_pos - shoulder_pos
			
			# Clamp reach distance so arm doesn't pull apart
			if from_shoulder.length() > max_reach:
				mouse_pos = shoulder_pos + from_shoulder.normalized() * max_reach
				
			var to_target = mouse_pos - hand.global_position
			var distance = to_target.length()
			
			# Proportional + derivative impulse for snappy spring response
			var target_vel = to_target.normalized() * min(distance * spring_strength, 1800.0)
			var impulse = (target_vel - hand.linear_velocity) * hand.mass * 0.85
			hand.apply_central_impulse(impulse)
		else:
			# Gentle resting gravity when released
			hand.apply_central_force(Vector2(0, 350.0 * hand.mass))

func is_dragging() -> bool:
	return dragging

func get_hand_velocity() -> Vector2:
	return hand.linear_velocity if hand else Vector2.ZERO

func get_hand_global_pos() -> Vector2:
	return hand.global_position if hand else global_position
