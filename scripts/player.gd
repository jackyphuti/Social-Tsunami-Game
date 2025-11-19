extends Node2D

# Player Arm Control Tuning
@export var walk_speed: float = 120.0  # Units/sec auto-walk speed (120-150 recommended)
@export var spring_strength: float = 25.0  # Spring constant for hand-to-mouse attraction (20-30 recommended)
@export var hand_mass: float = 0.3  # Mass of hand for impulse calculation

# Player script handles auto-walking and provides arm references.

var hand: RigidBody2D = null
var dragging: bool = false

func _ready() -> void:
    hand = $Arm/Hand
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    if has_node("DebugLabel"):
        $DebugLabel.text = "Hold LMB and drag to wave!\nWalking at %.0f units/sec" % walk_speed

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            dragging = event.pressed

func _physics_process(delta: float) -> void:
    # Simple auto-walk
    position.x += walk_speed * delta
    
    # Springy mouse-to-hand controller with tuned spring strength
    if dragging and hand:
        var mouse_pos: Vector2 = get_global_mouse_position()
        var to_target: Vector2 = mouse_pos - hand.global_position
        var desired_vel: Vector2 = to_target * spring_strength
        var impulse: Vector2 = (desired_vel - hand.linear_velocity) * hand_mass * delta * 0.5
        hand.apply_central_impulse(impulse)
