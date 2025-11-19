extends CanvasLayer

# UI Manager: displays Embarrassment Meter, Social Credit, and Score.
# Attach this script to a CanvasLayer in Main.tscn.

@onready var embarrassment_progress: ProgressBar = ProgressBar.new()
@onready var social_credit_progress: ProgressBar = ProgressBar.new()
@onready var score_label: Label = Label.new()
@onready var wave_feedback_label: Label = Label.new()

var game_manager: Node = null

func _ready() -> void:
	# Find the game manager in the parent scene
	if get_parent().has_node("GameManager"):
		game_manager = get_parent().get_node("GameManager")
	
	# Setup Embarrassment Progress Bar (top-left)
	embarrassment_progress.name = "EmbarrassmentProgress"
	embarrassment_progress.anchor_left = 0.0
	embarrassment_progress.anchor_top = 0.0
	embarrassment_progress.offset_left = 10
	embarrassment_progress.offset_top = 10
	embarrassment_progress.custom_minimum_size = Vector2(250, 20)
	embarrassment_progress.modulate = Color.RED
	embarrassment_progress.value = 0
	embarrassment_progress.max_value = 100
	add_child(embarrassment_progress)
	
	# Embarrassment Label
	var emb_label = Label.new()
	emb_label.text = "Embarrassment:"
	emb_label.anchor_left = 0.0
	emb_label.anchor_top = 0.0
	emb_label.offset_left = 10
	emb_label.offset_top = -15
	add_child(emb_label)
	
	# Setup Social Credit Progress Bar (top-center)
	social_credit_progress.name = "SocialCreditProgress"
	social_credit_progress.anchor_left = 0.0
	social_credit_progress.anchor_top = 0.0
	social_credit_progress.offset_left = 10
	social_credit_progress.offset_top = 40
	social_credit_progress.custom_minimum_size = Vector2(250, 20)
	social_credit_progress.modulate = Color.GREEN
	social_credit_progress.value = 100
	social_credit_progress.max_value = 100
	add_child(social_credit_progress)
	
	# Social Credit Label
	var sc_label = Label.new()
	sc_label.text = "Social Credit:"
	sc_label.anchor_left = 0.0
	sc_label.anchor_top = 0.0
	sc_label.offset_left = 10
	sc_label.offset_top = 25
	add_child(sc_label)
	
	# Setup Score Label (top-right)
	score_label.text = "Score: 0"
	score_label.anchor_left = 1.0
	score_label.anchor_top = 0.0
	score_label.offset_left = -150
	score_label.offset_top = 10
	add_child(score_label)
	
	# Setup Wave Feedback Label (center, appears briefly)
	wave_feedback_label.text = ""
	wave_feedback_label.anchor_left = 0.5
	wave_feedback_label.anchor_top = 0.5
	wave_feedback_label.offset_left = -100
	wave_feedback_label.offset_top = -20
	wave_feedback_label.custom_minimum_size = Vector2(200, 40)
	wave_feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wave_feedback_label.modulate = Color.WHITE
	add_child(wave_feedback_label)

func _physics_process(delta: float) -> void:
	if not game_manager:
		return
	
	# Update embarrassment bar
	embarrassment_progress.value = game_manager.embarrassment
	
	# Update social credit bar
	social_credit_progress.value = game_manager.social_credit
	
	# Update score label
	score_label.text = "Score: %d" % game_manager.score

func show_wave_feedback(text: String, color: Color, duration: float = 1.0) -> void:
	wave_feedback_label.text = text
	wave_feedback_label.modulate = color
	wave_feedback_label.modulate.a = 1.0
	
	# Fade out after duration
	var tween = create_tween()
	tween.tween_callback(func(): wave_feedback_label.modulate.a = 1.0)
	tween.tween_property(wave_feedback_label, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): wave_feedback_label.text = "")
