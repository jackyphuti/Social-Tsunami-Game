extends SceneTree

# Automated integration test script for Social Tsunami gameplay verification

func _init() -> void:
	print("[IntegrationTest] Starting automated gameplay tests...")
	
	# Ensure Global singleton exists
	var global_node = root.get_node_or_null("Global")
	if not global_node:
		global_node = load("res://scripts/global.gd").new()
		global_node.name = "Global"
		root.add_child(global_node)
		
	# Load Main scene
	var main_scene = load("res://scenes/Main.tscn")
	if not main_scene:
		push_error("FAILED to load Main.tscn")
		quit(1)
		return
		
	var main = main_scene.instantiate()
	root.add_child(main)
	
	# Give 1 frame for _ready to finish on all children
	main._ready()
	
	print("[IntegrationTest] Main scene instantiated successfully")
	
	# Verify critical nodes exist
	assert(main.has_node("Player"), "Player node missing")
	assert(main.has_node("NPCSpawner"), "NPCSpawner node missing")
	assert(main.has_node("WaveDetector"), "WaveDetector node missing")
	assert(main.has_node("SoundManager"), "SoundManager node missing")
	assert(main.has_node("UICanvas"), "UICanvas node missing")
	assert(main.has_node("PauseMenu"), "PauseMenu node missing")
	
	print("[IntegrationTest] All core nodes verified.")
	
	var player = main.get_node("Player")
	var spawner = main.get_node("NPCSpawner")
	var sound_mgr = main.get_node("SoundManager")
	var gm = main
	
	sound_mgr._ready()
	
	# Test 1: Verify audio loaded
	assert(sound_mgr.audio_players.size() >= 5, "Audio streams failed to initialize: %d" % sound_mgr.audio_players.size())
	print("[IntegrationTest] Test 1: Sound system passed (%d sounds loaded)" % sound_mgr.audio_players.size())
	
	# Test 2: Spawn an NPC manually and test interactions
	var npc = spawner.spawn_npc()
	assert(npc != null, "Failed to spawn NPC")
	print("[IntegrationTest] Test 2: NPC spawned at %s" % npc.position)
	
	# Test 3: Test Genuine Wave resolution
	npc.archetype = npc.Archetype.GENUINE_WAVE
	npc._start_gesture()
	assert(npc.is_active_interaction == true, "Interaction failed to start")
	
	var initial_score = gm.score
	npc.player_waved_at_me()
	assert(gm.score > initial_score, "Score did not increase on genuine wave success")
	assert(gm.streak == 1, "Streak did not increase on genuine wave success")
	print("[IntegrationTest] Test 3: Genuine wave success passed (Score: %d, Streak: %d)" % [gm.score, gm.streak])
	
	# Test 4: Test Fake-out dodge resolution
	var fake_npc = spawner.spawn_npc()
	fake_npc.archetype = fake_npc.Archetype.FAKE_OUT
	fake_npc._start_gesture()
	var prev_score = gm.score
	var prev_streak = gm.streak
	fake_npc._resolve_no_wave()
	assert(gm.score > prev_score, "Score did not increase on fakeout dodge")
	assert(gm.streak > prev_streak, "Streak did not increase on fakeout dodge")
	print("[IntegrationTest] Test 4: Fake-out dodge passed (Score: %d, Streak: %d)" % [gm.score, gm.streak])
	
	# Test 5: Test Cringe resolution on waving at fakeout
	var cringe_npc = spawner.spawn_npc()
	cringe_npc.archetype = cringe_npc.Archetype.FAKE_OUT
	cringe_npc._start_gesture()
	cringe_npc.player_waved_at_me()
	assert(gm.streak == 0, "Streak was not reset on cringe")
	assert(gm.embarrassment > 0, "Embarrassment did not increase on cringe")
	print("[IntegrationTest] Test 5: Cringe resolution passed (Embarrassment: %.1f, Streak reset to %d)" % [gm.embarrassment, gm.streak])
	
	# Test 6: Verify Global persistence
	global_node.set_final_stats({
		"score": gm.score,
		"max_streak": 4,
		"waves_greeted": 2,
		"fakeouts_dodged": 1
	})
	assert(global_node.high_score >= gm.score, "Global high score not updated")
	print("[IntegrationTest] Test 6: Global stats and persistence passed (High score: %d)" % global_node.high_score)
	
	print("\n>>> ALL INTEGRATION TESTS PASSED SUCCESSFULLY! <<<\n")
	quit(0)
