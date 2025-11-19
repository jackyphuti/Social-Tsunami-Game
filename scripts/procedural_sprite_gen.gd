extends Node

# Procedural Sprite Generator: creates vaporwave-style pastel NPC and player visuals at runtime.

# Pastel color palette for NPCs
const PASTEL_COLORS = [
	Color(0.9, 0.6, 0.8, 1.0),  # Pastel pink
	Color(0.7, 0.8, 0.95, 1.0),  # Pastel blue
	Color(0.85, 0.7, 0.9, 1.0),  # Pastel purple
	Color(0.9, 0.8, 0.6, 1.0),   # Pastel yellow
	Color(0.8, 0.9, 0.7, 1.0),   # Pastel green
]

static func get_random_pastel_color() -> Color:
	return PASTEL_COLORS[randi() % PASTEL_COLORS.size()]

static func create_npc_sprite() -> Image:
	"""Create a simple 32x48 pastel-colored NPC sprite."""
	var img = Image.create(32, 48, false, Image.FORMAT_RGBA8)
	var color = get_random_pastel_color()
	
	# Fill body (top 30 pixels)
	for y in range(30):
		for x in range(32):
			img.set_pixel(x, y, color)
	
	# Head (bottom 18 pixels)
	var head_color = color.lightened(0.15)
	for y in range(30, 48):
		for x in range(32):
			img.set_pixel(x, y, head_color)
	
	# Add simple gradient effect (left to right)
	var gradient = color.darkened(0.1)
	for y in range(48):
		for x in range(8):
			var blend = float(x) / 8.0
			var pixel = color.lerp(gradient, blend * 0.3)
			img.set_pixel(x, y, pixel)
	
	return img

static func create_arm_segment_sprite(width: int, height: int, base_color: Color = Color.WHITE) -> Image:
	"""Create a simple arm segment sprite."""
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	var seg_color = base_color.lightened(0.1)
	
	# Fill with gradient
	for y in range(height):
		for x in range(width):
			var y_blend = float(y) / float(height)
			var pixel = base_color.lerp(seg_color, y_blend * 0.4)
			img.set_pixel(x, y, pixel)
	
	return img

static func sprite_to_texture(img: Image) -> ImageTexture:
	"""Convert an Image to an ImageTexture."""
	return ImageTexture.create_from_image(img)
