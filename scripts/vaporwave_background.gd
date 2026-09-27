extends ColorRect

# Vaporwave Background: Renders a retro 80s synthwave aesthetic with animated perspective grid,
# glowing segmented sunset, parallax mountain silhouettes, and retro stars.

@export var scroll_speed: float = 160.0

var grid_offset: float = 0.0
var mountain_offset: float = 0.0
var palm_offset: float = 0.0
var stars: Array = []

const HORIZON_Y: float = 450.0
const VIEWPORT_WIDTH: float = 1280.0
const VIEWPORT_HEIGHT: float = 720.0

func _ready() -> void:
	color = Color(0.08, 0.03, 0.16, 1.0) # Deep dark violet base
	# Generate random star positions
	for i in range(45):
		stars.append({
			"pos": Vector2(randf_range(0, VIEWPORT_WIDTH), randf_range(20, HORIZON_Y - 80)),
			"size": randf_range(1.0, 2.5),
			"alpha": randf_range(0.4, 1.0),
			"speed": randf_range(0.8, 2.5)
		})
	print("[VaporwaveBackground] Aesthetic procedural background initialized")

func _process(delta: float) -> void:
	grid_offset = fmod(grid_offset + scroll_speed * delta * 0.7, 100.0)
	mountain_offset = fmod(mountain_offset + scroll_speed * delta * 0.15, VIEWPORT_WIDTH)
	palm_offset = fmod(palm_offset + scroll_speed * delta * 0.85, VIEWPORT_WIDTH * 1.5)
	queue_redraw()

func _draw() -> void:
	var total_w = VIEWPORT_WIDTH
	var total_h = VIEWPORT_HEIGHT
	
	# 1. Sky Gradient
	var sky_steps = 18
	for i in range(sky_steps):
		var y1 = (HORIZON_Y / float(sky_steps)) * i
		var y2 = (HORIZON_Y / float(sky_steps)) * (i + 1)
		var t = float(i) / float(sky_steps)
		# Deep Purple -> Hot Fuchsia -> Warm Sunset Peach
		var col: Color
		if t < 0.5:
			col = Color(0.10, 0.03, 0.20, 1.0).lerp(Color(0.70, 0.05, 0.45, 1.0), t * 2.0)
		else:
			col = Color(0.70, 0.05, 0.45, 1.0).lerp(Color(1.00, 0.55, 0.40, 1.0), (t - 0.5) * 2.0)
		draw_rect(Rect2(0, y1, total_w, y2 - y1 + 1), col)
		
	# 2. Twinkling Stars
	var time = Time.get_ticks_msec() / 1000.0
	for star in stars:
		var pulse = 0.5 + 0.5 * sin(time * star.speed + star.pos.x)
		var star_col = Color(0.9, 0.8, 1.0, star.alpha * pulse)
		draw_circle(star.pos, star.size, star_col)

	# 3. Retro Segmented Sunset Sun
	var sun_center = Vector2(VIEWPORT_WIDTH * 0.5, HORIZON_Y - 45)
	var sun_radius = 120.0
	
	# Glow behind sun
	draw_circle(sun_center, sun_radius + 18.0, Color(1.0, 0.2, 0.6, 0.15))
	draw_circle(sun_center, sun_radius + 8.0, Color(1.0, 0.6, 0.2, 0.25))
	
	# Draw sun base gradient slices
	var num_sun_slices = 32
	for i in range(num_sun_slices):
		var slice_y = (sun_center.y - sun_radius) + (2.0 * sun_radius / num_sun_slices) * i
		if slice_y >= HORIZON_Y:
			continue
		var slice_h = (2.0 * sun_radius / num_sun_slices) + 1.0
		var dy = (slice_y + slice_h * 0.5) - sun_center.y
		if abs(dy) < sun_radius:
			var half_w = sqrt(sun_radius * sun_radius - dy * dy)
			var sun_t = clampf((slice_y - (sun_center.y - sun_radius)) / (sun_radius * 2.0), 0.0, 1.0)
			# Top is bright yellow, bottom is magenta
			var slice_col = Color(1.0, 0.95, 0.4).lerp(Color(0.95, 0.15, 0.55), sun_t)
			draw_rect(Rect2(sun_center.x - half_w, slice_y, half_w * 2.0, slice_h), slice_col)
			
	# Draw iconic horizontal sun cuts (thicker towards bottom)
	for cut_i in range(1, 9):
		var cut_rel_y = pow(float(cut_i) / 9.0, 1.8) * sun_radius
		var cut_y = sun_center.y + cut_rel_y
		if cut_y < HORIZON_Y:
			var cut_thickness = 2.0 + cut_i * 1.8
			var dy = cut_y - sun_center.y
			if abs(dy) < sun_radius:
				var half_w = sqrt(sun_radius * sun_radius - dy * dy)
				draw_rect(Rect2(sun_center.x - half_w - 4, cut_y - cut_thickness * 0.5, half_w * 2.0 + 8, cut_thickness), Color(0.12, 0.04, 0.22, 1.0))

	# 4. Parallax Distant Mountains
	_draw_mountains(mountain_offset, total_w)

	# 5. Horizon Neon Glow Line
	draw_line(Vector2(0, HORIZON_Y), Vector2(total_w, HORIZON_Y), Color(0.0, 0.95, 1.0, 0.9), 3.0)
	draw_line(Vector2(0, HORIZON_Y - 1), Vector2(total_w, HORIZON_Y - 1), Color(1.0, 0.2, 0.8, 0.7), 2.0)

	# 6. Perspective 3D Neon Grid Floor
	_draw_perspective_grid(grid_offset, total_w, total_h)
	
	# 7. Parallax Neon Palm Tree Silhouettes
	_draw_palm_trees(palm_offset, total_w)

func _draw_mountains(offset: float, screen_w: float) -> void:
	var base_y = HORIZON_Y
	var peak_color = Color(0.18, 0.06, 0.32, 0.9)
	var wire_color = Color(0.85, 0.1, 0.65, 0.6)
	
	# Procedural mountain points across screen with repetition for infinite wrap
	var mountain_peaks = [
		Vector2(0, 0), Vector2(100, -50), Vector2(220, -110), Vector2(340, -40),
		Vector2(460, -140), Vector2(600, -30), Vector2(740, -100), Vector2(880, -160),
		Vector2(1020, -60), Vector2(1160, -120), Vector2(1280, 0)
	]
	
	for repeat in range(2):
		var x_shift = repeat * screen_w - offset
		var poly_pts: PackedVector2Array = []
		poly_pts.append(Vector2(x_shift, base_y))
		for p in mountain_peaks:
			poly_pts.append(Vector2(x_shift + p.x, base_y + p.y))
		poly_pts.append(Vector2(x_shift + screen_w, base_y))
		draw_polygon(poly_pts, [peak_color])
		
		# Draw neon wireframe ridges
		for i in range(mountain_peaks.size() - 1):
			var p1 = Vector2(x_shift + mountain_peaks[i].x, base_y + mountain_peaks[i].y)
			var p2 = Vector2(x_shift + mountain_peaks[i + 1].x, base_y + mountain_peaks[i + 1].y)
			draw_line(p1, p2, wire_color, 1.5)

func _draw_perspective_grid(offset: float, screen_w: float, screen_h: float) -> void:
	var floor_h = screen_h - HORIZON_Y
	var vanishing_x = screen_w * 0.5
	
	# Floor dark gradient background
	draw_rect(Rect2(0, HORIZON_Y, screen_w, floor_h), Color(0.06, 0.02, 0.14, 1.0))
	
	# Horizontal lines moving toward camera
	var num_horiz = 16
	for i in range(num_horiz):
		# Non-linear exponential spacing for 3D depth perception
		var t = float(i) + (offset / 100.0)
		var progress = fmod(t, float(num_horiz)) / float(num_horiz)
		var y = HORIZON_Y + pow(progress, 2.4) * floor_h
		var alpha = clampf(progress * 1.2, 0.1, 0.85)
		var line_w = 1.0 + progress * 2.0
		# Alternating Cyan and Magenta grid lines
		var grid_col = Color(0.0, 0.95, 1.0, alpha) if (i % 2 == 0) else Color(1.0, 0.15, 0.75, alpha)
		draw_line(Vector2(0, y), Vector2(screen_w, y), grid_col, line_w)

	# Perspective longitudinal lines radiating outward
	var num_radial = 28
	for i in range(num_radial + 1):
		var t = float(i) / float(num_radial)
		var bottom_x = lerpf(-screen_w * 0.6, screen_w * 1.6, t)
		var top_x = lerpf(vanishing_x - 300, vanishing_x + 300, t)
		draw_line(Vector2(top_x, HORIZON_Y), Vector2(bottom_x, screen_h), Color(0.8, 0.05, 0.7, 0.35), 1.5)

func _draw_palm_trees(offset: float, screen_w: float) -> void:
	# Draw periodic neon palm tree silhouettes along bottom sidewalk
	var tree_spacing = 600.0
	for i in range(4):
		var tree_x = fmod(i * tree_spacing - offset + screen_w * 2.0, screen_w * 1.8) - 100.0
		if tree_x > -150 and tree_x < screen_w + 150:
			_draw_single_palm(Vector2(tree_x, HORIZON_Y + 120))

func _draw_single_palm(pos: Vector2) -> void:
	var trunk_col = Color(0.08, 0.03, 0.18, 0.85)
	var leaf_col = Color(0.12, 0.04, 0.22, 0.9)
	var leaf_edge = Color(0.0, 0.9, 0.9, 0.4)
	
	# Curved trunk
	var h = 180.0
	var curve = 35.0
	var points: PackedVector2Array = [
		pos + Vector2(-6, 0),
		pos + Vector2(6, 0),
		pos + Vector2(curve + 4, -h * 0.5),
		pos + Vector2(curve + 2, -h),
		pos + Vector2(curve - 2, -h),
		pos + Vector2(curve - 4, -h * 0.5)
	]
	draw_polygon(points, [trunk_col])
	
	# Fronds / Leaves radiating from crown
	var crown = pos + Vector2(curve, -h)
	var angles = [-2.4, -2.0, -1.6, -1.2, -0.8, -0.4, 0.0]
	for a in angles:
		var tip = crown + Vector2(cos(a) * 70.0, sin(a) * 45.0 + 15.0)
		draw_line(crown, tip, leaf_col, 4.0)
		draw_line(crown, tip, leaf_edge, 1.5)
