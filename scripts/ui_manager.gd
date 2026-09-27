extends CanvasLayer

# UI Manager: Renders retro vaporwave HUD with Social Credit, Embarrassment, Score, Streak, and Alerts.

var game_manager: Node = null

@onready var embarrassment_bar: ProgressBar = $HUD/TopLeft/EmbarrassmentBar if has_node("HUD/TopLeft/EmbarrassmentBar") else null
@onready var embarrassment_label: Label = $HUD/TopLeft/EmbarrassmentLabel if has_node("HUD/TopLeft/EmbarrassmentLabel") else null

@onready var credit_bar: ProgressBar = $HUD/TopCenter/CreditBar if has_node("HUD/TopCenter/CreditBar") else null
@onready var credit_label: Label = $HUD/TopCenter/CreditLabel if has_node("HUD/TopCenter/CreditLabel") else null

@onready var score_label: Label = $HUD/TopRight/ScoreLabel if has_node("HUD/TopRight/ScoreLabel") else null
@onready var streak_label: Label = $HUD/TopRight/StreakLabel if has_node("HUD/TopRight/StreakLabel") else null

@onready var warning_banner: Label = $HUD/WarningBanner if has_node("HUD/WarningBanner") else null
@onready var low_credit_vignette: ColorRect = $LowCreditVignette if has_node("LowCreditVignette") else null

var warning_pulse_time: float = 0.0

func _ready() -> void:
	if get_parent():
		game_manager = get_parent()
	if warning_banner:
		warning_banner.visible = false
	if low_credit_vignette:
		low_credit_vignette.visible = false

func _process(delta: float) -> void:
	if game_manager:
		var credit = game_manager.get("social_credit")
		if credit != null and credit <= 25.0:
			warning_pulse_time += delta * 5.0
			var pulse = 0.4 + 0.3 * sin(warning_pulse_time)
			if warning_banner:
				warning_banner.visible = true
				warning_banner.modulate.a = pulse
			if low_credit_vignette:
				low_credit_vignette.visible = true
				low_credit_vignette.color = Color(1.0, 0.05, 0.2, pulse * 0.4)
		else:
			if warning_banner:
				warning_banner.visible = false
			if low_credit_vignette:
				low_credit_vignette.visible = false

func update_hud(score: int, credit: float, embarrassment: float, streak: int) -> void:
	if embarrassment_bar:
		embarrassment_bar.value = embarrassment
	if embarrassment_label:
		embarrassment_label.text = "EMBARRASSMENT: %d%%" % int(embarrassment)
		
	if credit_bar:
		credit_bar.value = credit
	if credit_label:
		credit_label.text = "SOCIAL CREDIT: %d / 100" % int(credit)
		
	if score_label:
		score_label.text = "SCORE: %d" % score
		
	if streak_label:
		if streak > 1:
			var mult = min(4, 1 + streak / 3)
			streak_label.text = "🔥 STREAK: %d (%dx PTS)" % [streak, mult]
			streak_label.visible = true
			var tween = create_tween()
			tween.tween_property(streak_label, "scale", Vector2(1.15, 1.15), 0.1)
			tween.tween_property(streak_label, "scale", Vector2.ONE, 0.1)
		else:
			streak_label.visible = false
