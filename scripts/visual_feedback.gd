extends Node2D

# Visual Feedback Manager: Screen shake, floating score text, wave ripples, and screen flashes.

var camera: Camera2D = null
var base_cam_offset: Vector2 = Vector2.ZERO
var shake_intensity: float = 0.0
var shake_timer: float = 0.0

@onready var flash_rect: ColorRect = $FlashRect if has_node("FlashRect") else null

func _ready() -> void:
	if get_parent():
		camera = get_parent().get_node_or_null("Camera2D")
		if camera:
			base_cam_offset = camera.offset

func _process(delta: float) -> void:
	if shake_timer > 0.0 and camera:
		shake_timer -= delta
		var offset_x = randf_range(-shake_intensity, shake_intensity)
		var offset_y = randf_range(-shake_intensity, shake_intensity)
		camera.offset = base_cam_offset + Vector2(offset_x, offset_y)
		if shake_timer <= 0.0:
			camera.offset = base_cam_offset

func screen_shake(intensity: float = 12.0, duration: float = 0.25) -> void:
	shake_intensity = intensity
	shake_timer = duration

func flash_screen(color: Color, duration: float = 0.25) -> void:
	if not flash_rect:
		return
	flash_rect.color = color
	flash_rect.modulate.a = 0.45
	var tween = create_tween()
	tween.tween_property(flash_rect, "modulate:a", 0.0, duration)

func spawn_floating_text(text: String, world_pos: Vector2, color: Color, font_size: int = 24) -> void:
	var label = Label.new()
	label.text = text
	label.position = world_pos + Vector2(-60, -30)
	label.modulate = color
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.z_index = 50
	add_child(label)
	
	# Animate float and fade
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 55.0, 0.85).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.15)
	tween.tween_property(label, "modulate:a", 0.0, 0.85).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(label.queue_free)

func spawn_wave_ripple(pos: Vector2) -> void:
	# Subtle neon expanding ring at hand location
	var ring = Line2D.new()
	var points: PackedVector2Array = []
	for i in range(17):
		var angle = (float(i) / 16.0) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * 10.0)
	ring.points = points
	ring.closed = true
	ring.width = 3.0
	ring.default_color = Color(0.0, 0.95, 1.0, 0.8)
	ring.position = pos
	ring.z_index = 30
	add_child(ring)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(ring, "scale", Vector2(3.5, 3.5), 0.3)
	tween.tween_property(ring, "modulate:a", 0.0, 0.3)
	tween.chain().tween_callback(ring.queue_free)
