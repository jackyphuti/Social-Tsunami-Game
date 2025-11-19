extends Node

# Sound Effects Manager: loads and plays audio files from res://sounds/
# Uses AudioStreamPlayer nodes dynamically created on demand.

var audio_players: Dictionary = {}
var sound_files: Dictionary = {
	"wave_success": "res://sounds/wave_success.wav",
	"wave_fail": "res://sounds/wave_fail.wav",
	"fake_out": "res://sounds/fake_out.wav",
	"social_credit_low": "res://sounds/social_credit_low.wav",
	"game_over": "res://sounds/game_over.wav",
	"bg_music": "res://sounds/bg_music.wav"
}

func _ready() -> void:
	print("[SoundManager] Initializing audio players...")
	_initialize_audio_players()

func _initialize_audio_players() -> void:
	for sound_name in sound_files.keys():
		var file_path = sound_files[sound_name]
		
		# Check if file exists
		if not ResourceLoader.exists(file_path):
			print("[SoundManager] WARNING: Audio file not found: %s" % file_path)
			continue
		
		# Create AudioStreamPlayer
		var player = AudioStreamPlayer.new()
		
		# Try to load the audio stream
		var audio_stream = ResourceLoader.load(file_path)
		if audio_stream:
			player.stream = audio_stream
			player.bus = "Master"
			add_child(player)
			audio_players[sound_name] = player
			print("[SoundManager] Loaded sound: %s" % sound_name)
		else:
			print("[SoundManager] Failed to load audio stream: %s" % file_path)

func _get_or_create_player(sound_name: String) -> AudioStreamPlayer:
	if sound_name in audio_players:
		return audio_players[sound_name]
	
	# Fallback: print warning and return null
	print("[SoundManager] Sound '%s' not available" % sound_name)
	return null

func play_wave_success() -> void:
	var player = _get_or_create_player("wave_success")
	if player:
		player.play()
		print("🔊 [SOUND] Wave success!")
	else:
		print("🔊 [SOUND] Wave success! (audio file not available)")

func play_wave_fail() -> void:
	var player = _get_or_create_player("wave_fail")
	if player:
		player.play()
		print("🔊 [SOUND] Wave failed!")
	else:
		print("🔊 [SOUND] Wave failed! (audio file not available)")

func play_fake_out_detected() -> void:
	var player = _get_or_create_player("fake_out")
	if player:
		player.play()
		print("🔊 [SOUND] Fake-out detected!")
	else:
		print("🔊 [SOUND] Fake-out detected! (audio file not available)")

func play_social_credit_low() -> void:
	var player = _get_or_create_player("social_credit_low")
	if player:
		player.play()
		print("🔊 [SOUND] Social credit low!")
	else:
		print("🔊 [SOUND] Social credit low! (audio file not available)")

func play_game_over() -> void:
	var player = _get_or_create_player("game_over")
	if player:
		player.play()
		print("🔊 [SOUND] Game over!")
	else:
		print("🔊 [SOUND] Game over! (audio file not available)")

func play_bg_music() -> void:
	var player = _get_or_create_player("bg_music")
	if player:
		player.bus = "Music"  # Optional: route to a separate bus
		player.play()
		print("🔊 [SOUND] Background music started")
	else:
		print("🔊 [SOUND] Background music unavailable")

func stop_all() -> void:
	print("[SoundManager] Stopping all sounds")
	for key in audio_players:
		if audio_players[key]:
			audio_players[key].stop()
