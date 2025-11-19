extends Node2D

@export var speed: float = 120.0
@export var spring_k: float = 20.0
@export var damping: float = 6.0

# Player script handles auto-walking and provides arm references.

var hand: RigidBody2D = null
var dragging: bool = false

func _ready() -> void:
    hand = $Arm/Hand
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    if has_node("DebugLabel"):
        $DebugLabel.text = "Hold LMB and drag to wave!\nWalking at %.0f units/sec" % speed

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            dragging = event.pressed

func _physics_process(delta: float) -> void:
    # Simple auto-walk
    position.x += speed * delta
    
    # Springy mouse-to-hand controller
    if dragging and hand:
        var mouse_pos: Vector2 = get_global_mouse_position()
        var to_target: Vector2 = mouse_pos - hand.global_position
        var desired_vel: Vector2 = to_target * spring_k
        var mass: float = hand.mass if hand.has_meta("mass") else 1.0
        var impulse: Vector2 = (desired_vel - hand.linear_velocity) * mass * delta * 0.5
        hand.apply_central_impulse(impulse)
