extends Node2D

# NPC: Handles walking, gestures, speech bubbles, and wave/fake-out resolutions.

signal interaction_started(npc: Node2D)
signal interaction_resolved(npc: Node2D, result: String)

enum Archetype {
	GENUINE_WAVE,
	FAKE_OUT,
	BEHIND_YOU,
	VIP_WAVER
}

@export var walk_speed: float = 190.0

var archetype: Archetype = Archetype.GENUINE_WAVE
var is_active_interaction: bool = false
var has_started_gesture: bool = false
var has_resolved: bool = false

var gesture_time: float = 0.0
var walk_time: float = 0.0

@onready var arm_visual: Node2D = $BodyVisual/Arm if has_node("BodyVisual/Arm") else null
@onready var body_visual: Node2D = $BodyVisual if has_node("BodyVisual") else null
@onready var speech_bubble: Control = $SpeechBubble if has_node("SpeechBubble") else null
@onready var speech_label: Label = $SpeechBubble/Margin/Label if has_node("SpeechBubble/Margin/Label") else null
@onready var face_label: Label = $BodyVisual/Head/FaceLabel if has_node("BodyVisual/Head/FaceLabel") else null
@onready var vip_glow: Polygon2D = $BodyVisual/VIPGlow if has_node("BodyVisual/VIPGlow") else null

func _ready() -> void:
	_setup_archetype()
	_apply_procedural_visuals()
	if speech_bubble:
		speech_bubble.visible = false
		speech_bubble.scale = Vector2.ZERO

func _setup_archetype() -> void:
	var roll = randf()
	if roll < 0.58:
		archetype = Archetype.GENUINE_WAVE
	elif roll < 0.78:
		archetype = Archetype.FAKE_OUT
	elif roll < 0.92:
		archetype = Archetype.BEHIND_YOU
	else:
		archetype = Archetype.VIP_WAVER
		
	if vip_glow:
		vip_glow.visible = (archetype == Archetype.VIP_WAVER)

func _apply_procedural_visuals() -> void:
	var sp_gen = preload("res://scripts/procedural_sprite_gen.gd")
	var shirt_col = sp_gen.get_random_shirt()
	var hair_col = sp_gen.get_random_hair()
	var skin_col = sp_gen.get_random_skin()
	
	if has_node("BodyVisual/Torso"):
		$BodyVisual/Torso.color = shirt_col
	if has_node("BodyVisual/Head/Face"):
		$BodyVisual/Head/Face.color = skin_col
	if has_node("BodyVisual/Head/Hair"):
		$BodyVisual/Head/Hair.color = hair_col
	if has_node("BodyVisual/Arm/Visual"):
		$BodyVisual/Arm/Visual.color = shirt_col
	if has_node("BodyVisual/Arm/Hand"):
		$BodyVisual/Arm/Hand.color = skin_col

func _physics_process(delta: float) -> void:
	# Walk left toward player
	position.x -= walk_speed * delta
	walk_time += delta * 6.0
	
	# Walking bob
	if body_visual:
		body_visual.position.y = sin(walk_time) * 3.0
	
	# Check trigger zone to start gesture (in clear view on screen)
	if not has_started_gesture and position.x <= 840.0:
		_start_gesture()
		
	# Animate gesture
	if has_started_gesture:
		gesture_time += delta
		_animate_gesture(delta)
		
	# Check expiration zone: if NPC walks past player (x <= 350) without player waving
	if is_active_interaction and position.x <= 350.0:
		_resolve_no_wave()
		
	# Despawn when completely offscreen to the left
	if position.x < -140.0:
		queue_free()

func _start_gesture() -> void:
	has_started_gesture = true
	is_active_interaction = true
	gesture_time = 0.0
	
	_show_speech_bubble()
	interaction_started.emit(self)

func _show_speech_bubble() -> void:
	if not speech_bubble:
		return
		
	var text = ""
	var bubble_col = Color.WHITE
	
	match archetype:
		Archetype.GENUINE_WAVE:
			var greetings = ["👋 Hey!", "👋 Yo!", "👋 Hello!", "👋 Over here!"]
			text = greetings[randi() % greetings.size()]
			bubble_col = Color(0.2, 0.9, 0.9, 1.0)
		Archetype.FAKE_OUT:
			var hair_texts = ["💇 *flips hair*", "🕶️ *shades check*", "🪞 *fixing hair*"]
			text = hair_texts[randi() % hair_texts.size()]
			bubble_col = Color(1.0, 0.4, 0.7, 1.0)
		Archetype.BEHIND_YOU:
			var behind_texts = ["👤 Behind you!", "👤 Dave! Over here!", "👤 Hey guys!"]
			text = behind_texts[randi() % behind_texts.size()]
			bubble_col = Color(1.0, 0.75, 0.2, 1.0)
		Archetype.VIP_WAVER:
			text = "✨ YOOOO!! ✨"
			bubble_col = Color(1.0, 0.9, 0.2, 1.0)
			
	if speech_label:
		speech_label.text = text
		
	if speech_bubble.has_node("Panel"):
		speech_bubble.get_node("Panel").modulate = bubble_col
		
	speech_bubble.visible = true
	var tween = create_tween()
	tween.tween_property(speech_bubble, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _animate_gesture(delta: float) -> void:
	if not arm_visual:
		return
		
	match archetype:
		Archetype.GENUINE_WAVE, Archetype.VIP_WAVER:
			# Upward waving back and forth
			var wave_angle = -1.6 + sin(gesture_time * 9.0) * 0.55
			arm_visual.rotation = wave_angle
		Archetype.FAKE_OUT:
			# Arm raises to touch head/hair, stays briefly, then drops
			if gesture_time < 0.6:
				arm_visual.rotation = lerpf(0.0, -2.4, gesture_time / 0.6)
			elif gesture_time < 1.4:
				arm_visual.rotation = -2.4 + sin(gesture_time * 12.0) * 0.15
			else:
				arm_visual.rotation = lerpf(-2.4, 0.0, min(1.0, (gesture_time - 1.4) * 2.0))
		Archetype.BEHIND_YOU:
			# Reaching way up and pointing past
			var reach_angle = -2.1 + sin(gesture_time * 6.0) * 0.25
			arm_visual.rotation = reach_angle

func player_waved_at_me() -> void:
	if not is_active_interaction or has_resolved:
		return
		
	has_resolved = true
	is_active_interaction = false
	
	if archetype == Archetype.GENUINE_WAVE or archetype == Archetype.VIP_WAVER:
		# Greeted real wave -> SUCCESS!
		if face_label:
			face_label.text = "(^▽^)"
		if speech_label:
			speech_label.text = "❤️ Awesome!"
		interaction_resolved.emit(self, "SUCCESS")
	else:
		# Greeted fake-out or behind-you -> CRINGE!
		if face_label:
			face_label.text = "(-_-;)"
		if speech_label:
			speech_label.text = "❓ Uh... who are you?"
		interaction_resolved.emit(self, "CRINGE")

func _resolve_no_wave() -> void:
	if not is_active_interaction or has_resolved:
		return
		
	has_resolved = true
	is_active_interaction = false
	
	if archetype == Archetype.GENUINE_WAVE or archetype == Archetype.VIP_WAVER:
		# Ignored a genuine wave -> MISSED!
		if face_label:
			face_label.text = "(T_T)"
		if speech_label:
			speech_label.text = "💔 Awkward..."
		interaction_resolved.emit(self, "MISSED")
	else:
		# Ignored fake-out / behind-you -> DODGED!
		if face_label:
			face_label.text = "(•‿•)"
		if speech_label:
			speech_label.text = "✨ *phew*"
		interaction_resolved.emit(self, "DODGED")

func is_genuine_wave() -> bool:
	return archetype == Archetype.GENUINE_WAVE or archetype == Archetype.VIP_WAVER

func is_vip() -> bool:
	return archetype == Archetype.VIP_WAVER
