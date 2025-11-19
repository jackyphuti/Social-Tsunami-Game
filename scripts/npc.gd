extends Node2D

# NPC script: handles waving behavior, fake-outs, and emits signals.

signal on_wave_start(is_fake_out: bool)
signal on_wave_end

# NPC Movement & Wave Timing Tuning
@export var walk_speed: float = 60.0  # Units/sec moving left toward player (50-80 recommended)
@export var wave_duration: float = 1.5  # Seconds an NPC waves (1.0-2.0 recommended)
@export var fake_out_chance: float = 0.3  # Probability of fake-out (0.2-0.5 recommended)

var is_waving: bool = false
var is_fake_out: bool = false
var waving_time: float = 0.0
var npc_color: Color

func _ready() -> void:
	randomize()
	# Randomly decide if this NPC waves or is a fake-out based on tuned chance
	is_fake_out = randf() < fake_out_chance
	
	# Generate a unique pastel color for this NPC
	npc_color = preload("res://scripts/procedural_sprite_gen.gd").get_random_pastel_color()
	
	# Update Body color to the new pastel color
	if has_node("Body"):
		$Body.color = npc_color
	
	# Start waving after a short delay
	if has_node("WaveTimer"):
		$WaveTimer.wait_time = randf_range(0.5, 2.0)
		$WaveTimer.start()
		$WaveTimer.timeout.connect(_on_wave_timer_timeout)

	# Ensure WaveArea has a CollisionShape2D with a RectangleShape2D shape at runtime
	if has_node("WaveArea") and $WaveArea.has_node("CollisionShape2D"):
		var cs = $WaveArea.get_node("CollisionShape2D")
		if cs and not cs.shape:
			var rect = RectangleShape2D.new()
			rect.extents = Vector2(16, 32)
			cs.shape = rect

func _physics_process(delta: float) -> void:
	# Walk left (toward the player at x=0) using tuned walk speed
	position.x -= walk_speed * delta
	
	# Update waving state
	if is_waving:
		waving_time += delta
		if waving_time >= wave_duration:
			is_waving = false
			waving_time = 0.0
			on_wave_end.emit()
		else:
			# Animate wave (visual feedback)
			var arm_rotation = sin(waving_time * 6.0) * 0.4
			if has_node("Body"):
				$Body.rotation = arm_rotation
	
	# Remove NPC if it goes too far left
	if position.x < -100:
		queue_free()

func _on_wave_timer_timeout() -> void:
	# Start waving
	is_waving = true
	waving_time = 0.0
	on_wave_start.emit(is_fake_out)
	
	# Update label
	if has_node("Label"):
		if is_fake_out:
			$Label.text = "Hair"
			$Body.color = Color(0.8, 0.6, 0.6, 1)  # reddish = fake-out
		else:
			$Label.text = "Wave"
			$Body.color = Color(0.6, 0.7, 0.9, 1)  # blueish = real wave

func is_waving_now() -> bool:
	return is_waving

func get_is_fake_out() -> bool:
	return is_fake_out
