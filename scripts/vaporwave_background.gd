extends CanvasLayer

# Vaporwave Background: creates a gradient-based parallax background with retro aesthetic.

@export var bg_color_bottom: Color = Color(0.1, 0.05, 0.2, 1.0)  # Deep purple
@export var bg_color_top: Color = Color(0.8, 0.2, 0.6, 1.0)  # Hot pink
@export var horizon_color: Color = Color(0.9, 0.5, 0.7, 1.0)  # Pastel pink

var viewport_size: Vector2

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	queue_redraw()

func _draw() -> void:
	# Draw gradient background (top to horizon to bottom for vaporwave effect)
	var horizon_y = viewport_size.y * 0.4
	
	# Top sky gradient (bright, pastel)
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
	draw_rect(Rect2(0, 0, viewport_size.x, horizon_y), bg_color_top)
	
	# Horizon transition
	draw_rect(Rect2(0, horizon_y, viewport_size.x, viewport_size.y * 0.3), horizon_color)
	
	# Bottom gradient (darker)
	draw_rect(Rect2(0, horizon_y + viewport_size.y * 0.3, viewport_size.x, viewport_size.y * 0.3), bg_color_bottom)
	
	# Draw some horizontal parallax lines for depth
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
	for i in range(5):
		var line_y = horizon_y + i * 20
		var line_alpha = 0.15 - (i * 0.03)
		draw_line(Vector2(0, line_y), Vector2(viewport_size.x, line_y), Color(1, 0.8, 1, line_alpha), 1.0)
