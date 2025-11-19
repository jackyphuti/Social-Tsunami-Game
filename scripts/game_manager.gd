extends Node2D

# Game Manager: orchestrates the game loop, score, and NPC/wave interaction.

@export var start_embarrassment: float = 0.0
@export var start_social_credit: float = 100.0

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
		get_tree().reload_current_scene()

func _on_wave_detected(is_correct: bool, npc: Node2D) -> void:
	if is_correct:
		# Correct wave
		score += 10
		social_credit = min(social_credit + 5, 100)
		print("✓ Correct wave! +10 points, +5 social credit. Total: %d / %.1f" % [score, social_credit])
		if sound_manager:
			sound_manager.play_wave_success()
	else:
		# Wrong wave or missed wave
		embarrassment += 10
		social_credit = max(social_credit - 15, 0)
		print("✗ Wrong wave! +10 embarrassment, -15 social credit. Total: %.1f / %.1f" % [embarrassment, social_credit])
		if sound_manager:
			sound_manager.play_wave_fail()
	
	# Check for social credit warning
	if social_credit <= 25 and sound_manager:
		sound_manager.play_social_credit_low()
	
	# End game if social credit reaches 0
	if social_credit <= 0:
		print("Game Over! Social credit exhausted.")
		if sound_manager:
			sound_manager.play_game_over()
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
