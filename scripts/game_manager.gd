extends Node2D

# Game Manager: Master gameplay coordinator for scoring, streaks, NPC interactions, audio, and UI.

@export var start_social_credit: float = 100.0
@export var start_embarrassment: float = 0.0

var score: int = 0
var social_credit: float = 100.0
var embarrassment: float = 0.0
var streak: int = 0
var max_streak: int = 0
var waves_greeted: int = 0
var fakeouts_dodged: int = 0

var is_game_over: bool = false

@onready var npc_spawner: Node2D = $NPCSpawner if has_node("NPCSpawner") else null
@onready var ui_manager: CanvasLayer = $UICanvas if has_node("UICanvas") else null
@onready var visual_feedback: Node2D = $VisualFeedback if has_node("VisualFeedback") else null
@onready var sound_manager: Node = $SoundManager if has_node("SoundManager") else null
@onready var wave_detector: Node = $WaveDetector if has_node("WaveDetector") else null
@onready var player: Node2D = $Player if has_node("Player") else null

func _ready() -> void:
	social_credit = start_social_credit
	embarrassment = start_embarrassment
	
	if npc_spawner and not npc_spawner.npc_spawned.is_connected(_on_npc_spawned):
		npc_spawner.npc_spawned.connect(_on_npc_spawned)
		
	if wave_detector and not wave_detector.player_performed_wave.is_connected(_on_player_wave):
		wave_detector.player_performed_wave.connect(_on_player_wave)
		
	_update_ui()
	print("[GameManager] Game started! Initial Social Credit: %.0f" % social_credit)

func _get_global() -> Node:
	if has_node("/root/Global"):
		return get_node("/root/Global")
	return null

func _on_npc_spawned(npc: Node2D) -> void:
	if npc.has_signal("interaction_resolved") and not npc.interaction_resolved.is_connected(_on_npc_interaction_resolved):
		npc.interaction_resolved.connect(_on_npc_interaction_resolved)

func _on_player_wave(pos: Vector2) -> void:
	if visual_feedback:
		visual_feedback.spawn_wave_ripple(pos)

func _on_npc_interaction_resolved(npc: Node2D, result: String) -> void:
	if is_game_over:
		return
		
	var mult = min(4, 1 + streak / 3)
	var npc_pos = npc.global_position if npc else Vector2(400, 360)
	var is_vip = npc.get("archetype") == 3 if npc else false
	
	match result:
		"SUCCESS":
			streak += (2 if is_vip else 1)
			max_streak = max(max_streak, streak)
			waves_greeted += 1
			
			var pts = (35 if is_vip else 15) * mult
			score += pts
			social_credit = min(100.0, social_credit + (10.0 if is_vip else 6.0))
			embarrassment = max(0.0, embarrassment - 5.0)
			
			if visual_feedback:
				visual_feedback.flash_screen(Color(0.2, 0.95, 0.5), 0.2)
				var text = "+%d VIP WAVE!" % pts if is_vip else "+%d NICE WAVE!" % pts
				if mult > 1:
					text += " (%dx)" % mult
				visual_feedback.spawn_floating_text(text, npc_pos, Color(0.2, 1.0, 0.7), 26)
				
			if sound_manager:
				sound_manager.play_wave_success(streak)
				
		"DODGED":
			streak += 1
			max_streak = max(max_streak, streak)
			fakeouts_dodged += 1
			
			var pts = 10 * mult
			score += pts
			social_credit = min(100.0, social_credit + 3.0)
			embarrassment = max(0.0, embarrassment - 3.0)
			
			if visual_feedback:
				visual_feedback.flash_screen(Color(0.0, 0.8, 1.0), 0.15)
				var text = "+%d DODGED! Smooth" % pts
				visual_feedback.spawn_floating_text(text, npc_pos, Color(0.3, 0.9, 1.0), 22)
				
			if sound_manager:
				sound_manager.play_fake_out_detected()
				
		"CRINGE":
			streak = 0
			social_credit = max(0.0, social_credit - 15.0)
			embarrassment = min(100.0, embarrassment + 15.0)
			
			if visual_feedback:
				visual_feedback.screen_shake(14.0, 0.3)
				visual_feedback.flash_screen(Color(1.0, 0.1, 0.3), 0.3)
				visual_feedback.spawn_floating_text("-15 CRINGE! Awkward...", npc_pos, Color(1.0, 0.25, 0.4), 24)
				
			if sound_manager:
				sound_manager.play_wave_fail()
				
		"MISSED":
			streak = 0
			social_credit = max(0.0, social_credit - 12.0)
			embarrassment = min(100.0, embarrassment + 10.0)
			
			if visual_feedback:
				visual_feedback.screen_shake(7.0, 0.2)
				visual_feedback.spawn_floating_text("-12 MISSED! Ignored...", npc_pos, Color(0.9, 0.5, 0.2), 22)
				
			if sound_manager:
				sound_manager.play_wave_fail()

	# Audio warning for low credit
	if social_credit <= 25.0 and social_credit > 0.0 and sound_manager:
		sound_manager.play_social_credit_low()

	_update_ui()
	
	if social_credit <= 0.0:
		_trigger_game_over()

func _update_ui() -> void:
	if ui_manager and ui_manager.has_method("update_hud"):
		ui_manager.update_hud(score, social_credit, embarrassment, streak)

func _trigger_game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	print("[GameManager] GAME OVER! Final Score: %d" % score)
	
	if npc_spawner and npc_spawner.has_method("stop_spawning"):
		npc_spawner.stop_spawning()
		
	if sound_manager:
		sound_manager.play_game_over()
		
	# Store final stats in Global singleton
	var global = _get_global()
	if global and global.has_method("set_final_stats"):
		global.set_final_stats({
			"score": score,
			"embarrassment": embarrassment,
			"social_credit": social_credit,
			"max_streak": max_streak,
			"waves_greeted": waves_greeted,
			"fakeouts_dodged": fakeouts_dodged
		})
	
	# Transition after brief pause so player feels the defeat
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://scenes/EndScreen.tscn")
