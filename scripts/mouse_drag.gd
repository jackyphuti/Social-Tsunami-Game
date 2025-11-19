extends Node

# Springy mouse-to-hand controller.
# Attach as a child of the Player node. It applies impulses to the hand RigidBody2D
# to make it follow the mouse with a springy, slightly-unwieldy feel.

const SPRING_K := 20.0
const DAMPING := 6.0

var dragging: bool = false
var hand: RigidBody2D = null

func _ready() -> void:
    # find the hand in the parent (Player/Arm/Hand)
    if get_parent() and get_parent().has_node("Arm/Hand"):
        hand = get_parent().get_node("Arm/Hand") as RigidBody2D

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            dragging = event.pressed

func _physics_process(delta: float) -> void:
    if not hand:
        return
    if dragging:
        var mouse_pos: Vector2 = get_global_mouse_position()
        var to_target: Vector2 = mouse_pos - hand.global_position
        # Desired velocity to reduce distance (spring behaviour)
        var desired_vel: Vector2 = to_target * SPRING_K
        # PD-ish control: impulse = (desired - current_vel) * mass * small_factor
        var mass = hand.mass if hasattr(hand, "mass") else 1.0
        var impulse: Vector2 = (desired_vel - hand.linear_velocity) * mass * delta
        hand.apply_central_impulse(impulse)
