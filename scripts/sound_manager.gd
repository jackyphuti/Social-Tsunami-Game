extends Node

# Sound Effects & Music Manager: loads and plays audio files from res://sounds/

var audio_players: Dictionary = {}
var sound_files: Dictionary = {
	"wave_success": "res://sounds/wave_success.wav",
	"wave_fail": "res://sounds/wave_fail.wav",
	"fake_out": "res://sounds/fake_out.wav",
	"social_credit_low": "res://sounds/social_credit_low.wav",
	"game_over": "res://sounds/game_over.wav",
	"bg_music": "res://sounds/bg_music.wav"
}

var bg_player: AudioStreamPlayer = null
var is_music_playing: bool = false
var last_low_credit_play: float = -999.0

func _ready() -> void:
	print("[SoundManager] Initializing audio players...")
	_initialize_audio_players()
	play_bg_music()

func _initialize_audio_players() -> void:
	for sound_name in sound_files.keys():
		var file_path = sound_files[sound_name]
		if not ResourceLoader.exists(file_path):
			print("[SoundManager] WARNING: Audio file not found: %s" % file_path)
			continue
		
		var audio_stream = ResourceLoader.load(file_path)
		if audio_stream:
			var player = AudioStreamPlayer.new()
			player.stream = audio_stream
			player.bus = "Master"
			add_child(player)
			audio_players[sound_name] = player
			print("[SoundManager] Loaded sound: %s" % sound_name)
		else:
			print("[SoundManager] Failed to load audio stream: %s" % file_path)

func _get_player(sound_name: String) -> AudioStreamPlayer:
	return audio_players.get(sound_name, null)

func play_bg_music() -> void:
	bg_player = _get_player("bg_music")
	if bg_player and bg_player.is_inside_tree() and not is_music_playing:
		bg_player.volume_db = -8.0
		# Seamless loop connection
		if not bg_player.finished.is_connected(_on_bg_music_finished):
			bg_player.finished.connect(_on_bg_music_finished)
		bg_player.play()
		is_music_playing = true
		print("[SoundManager] Background music started")

func _on_bg_music_finished() -> void:
	if is_music_playing and bg_player and bg_player.is_inside_tree():
		bg_player.play()

func stop_bg_music() -> void:
	if bg_player and bg_player.is_inside_tree():
		bg_player.stop()
		is_music_playing = false

func play_wave_success(streak: int = 1) -> void:
	var player = _get_player("wave_success")
	if player and player.is_inside_tree():
		var pitch = clampf(1.0 + (streak - 1) * 0.05, 0.9, 1.4)
		player.pitch_scale = pitch
		player.volume_db = -2.0
		player.play()

func play_wave_fail() -> void:
	var player = _get_player("wave_fail")
	if player and player.is_inside_tree():
		player.pitch_scale = randf_range(0.95, 1.05)
		player.volume_db = 0.0
		player.play()

func play_fake_out_detected() -> void:
	var player = _get_player("fake_out")
	if player and player.is_inside_tree():
		player.pitch_scale = randf_range(0.98, 1.05)
		player.volume_db = -3.0
		player.play()

func play_social_credit_low() -> void:
	var now = Time.get_ticks_msec() / 1000.0
	if now - last_low_credit_play < 2.5:
		return
	last_low_credit_play = now
	var player = _get_player("social_credit_low")
	if player and player.is_inside_tree():
		player.volume_db = 1.0
		player.play()

func play_game_over() -> void:
	stop_bg_music()
	var player = _get_player("game_over")
	if player and player.is_inside_tree():
		player.volume_db = 2.0
		player.play()

func play_button_click() -> void:
	var player = _get_player("fake_out")
	if player and player.is_inside_tree():
		player.pitch_scale = 1.5
		player.volume_db = -6.0
		player.play()

func stop_all() -> void:
	print("[SoundManager] Stopping all sounds")
	for key in audio_players:
		var p = audio_players[key]
		if p and p.is_inside_tree():
			p.stop()
	is_music_playing = false
