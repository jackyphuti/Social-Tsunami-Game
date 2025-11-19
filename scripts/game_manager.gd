extends Node2D

# Game Manager: orchestrates the game loop, score, and NPC/wave interaction.

# Scoring & Meter Tuning
@export var start_embarrassment: float = 0.0
@export var start_social_credit: float = 100.0
@export var correct_wave_score: int = 10  # Points for correct wave (8-15 recommended)
@export var correct_wave_credit: float = 5.0  # Social credit gain (3-8 recommended)
@export var wrong_wave_embarrassment: float = 10.0  # Embarrassment increase (8-15 recommended)
@export var wrong_wave_credit: float = 15.0  # Social credit loss (10-20 recommended)
@export var social_credit_warning_threshold: float = 25.0  # Play warning sound when below this

var embarrassment: float = 0.0
var social_credit: float = 100.0
var score: int = 0
var wave_detector: Node = null
var sound_manager: Node = null
var ui_manager: Node = null

func _ready() -> void:
	embarrassment = start_embarrassment
	social_credit = start_social_credit
	
	# Setup wave detector
	wave_detector = preload("res://scripts/wave_detector.gd").new()
	wave_detector.name = "WaveDetector"
	add_child(wave_detector)
	if wave_detector.has_signal("wave_detected"):
		wave_detector.wave_detected.connect(_on_wave_detected)
	
	# Setup sound manager
	sound_manager = preload("res://scripts/sound_manager.gd").new()
	sound_manager.name = "SoundManager"
	add_child(sound_manager)
	
	# Get UI manager reference
	if get_parent().has_node("UICanvas"):
		ui_manager = get_parent().get_node("UICanvas")
	
	print("Game started: Social Credit = %.1f, Embarrassment = %.1f" % [social_credit, embarrassment])

func _physics_process(delta: float) -> void:
	# Check if game is over
	if social_credit <= 0:
		print("Game Over! Social credit exhausted.")
		_end_game()

func _on_wave_detected(is_correct: bool, npc: Node2D) -> void:
	if is_correct:
		# Correct wave
		score += correct_wave_score
		social_credit = min(social_credit + correct_wave_credit, 100)
		print("✓ Correct wave! +%d points, +%.1f social credit. Total: %d / %.1f" % [correct_wave_score, correct_wave_credit, score, social_credit])
		if sound_manager:
			sound_manager.play_wave_success()
	else:
		# Wrong wave or missed wave
		embarrassment += wrong_wave_embarrassment
		social_credit = max(social_credit - wrong_wave_credit, 0)
		print("✗ Wrong wave! +%.1f embarrassment, -%.1f social credit. Total: %.1f / %.1f" % [wrong_wave_embarrassment, wrong_wave_credit, embarrassment, social_credit])
		if sound_manager:
			sound_manager.play_wave_fail()
	
	# Check for social credit warning
	if social_credit <= social_credit_warning_threshold and sound_manager:
		sound_manager.play_social_credit_low()
	
	# End game if social credit reaches 0
	if social_credit <= 0:
		print("Game Over! Social credit exhausted.")
		if sound_manager:
			sound_manager.play_game_over()
		await get_tree().create_timer(1.0).timeout
		_end_game()

func _end_game() -> void:
	# Store final stats in Global and transition to EndScreen
	if Global.has_method("set_final_stats"):
		Global.set_final_stats({
			"score": score,
			"embarrassment": embarrassment,
			"social_credit": social_credit
		})
	print("[GameManager] Transitioning to end screen...")
	get_tree().change_scene_to_file("res://scenes/EndScreen.tscn")
