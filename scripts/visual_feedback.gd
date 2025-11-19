extends Node

# Visual Feedback Manager: handles particle effects and screen shake.
# Currently uses simple visual effects; can be enhanced with sprite particles later.

var game_manager: Node = null

func _ready() -> void:
	# Get game manager reference
	if get_parent().has_node("GameManager"):
		game_manager = get_parent().get_node("GameManager")

func screen_shake(intensity: float = 0.5, duration: float = 0.2) -> void:
	# Screen shake effect on embarrassment
	var camera = get_parent().get_node("Player/Camera2D")
	if not camera:
		return
	
	var original_offset = camera.offset
	var tween = create_tween()
	for i in range(int(duration * 60)):  # ~60 FPS
		var shake_x = randf_range(-intensity, intensity)
		var shake_y = randf_range(-intensity, intensity)
		camera.offset = original_offset + Vector2(shake_x, shake_y)
		await get_tree().create_timer(0.016).timeout
	
	camera.offset = original_offset

func pulse_ui(color: Color, duration: float = 0.3) -> void:
	# Pulse effect on UI
	var ui_canvas = get_parent().get_node("UICanvas")
	if not ui_canvas:
		return
	
	var original_color = ui_canvas.modulate
	var tween = create_tween()
	tween.tween_property(ui_canvas, "modulate", color, duration / 2.0)
	tween.tween_property(ui_canvas, "modulate", original_color, duration / 2.0)

func play_wave_success_feedback() -> void:
	# Green pulse on success
	pulse_ui(Color.GREEN, 0.3)

func play_wave_fail_feedback() -> void:
	# Red flash + screen shake on failure
	screen_shake(1.0, 0.2)
	pulse_ui(Color.RED, 0.3)
