extends ColorRect

# Vaporwave Background: creates a gradient-based background with retro aesthetic.

@export var bg_color_bottom: Color = Color(0.1, 0.05, 0.2, 1.0)  # Deep purple
@export var bg_color_top: Color = Color(0.8, 0.2, 0.6, 1.0)  # Hot pink
@export var horizon_color: Color = Color(0.9, 0.5, 0.7, 1.0)  # Pastel pink

func _ready() -> void:
	# Create a gradient for the background
	var gradient = Gradient.new()
	gradient.add_point(0.0, bg_color_top)
	gradient.add_point(0.4, horizon_color)
	gradient.add_point(1.0, bg_color_bottom)
	
	# Create gradient texture
	var gradient_tex = GradientTexture1D.new()
	gradient_tex.gradient = gradient
	gradient_tex.width = 256
	
	# Apply to ColorRect
	self.color = bg_color_bottom
	
	# Simple solid color background for now (gradient drawing removed for compatibility)
	print("[VaporwaveBackground] Background initialized with vaporwave colors")
