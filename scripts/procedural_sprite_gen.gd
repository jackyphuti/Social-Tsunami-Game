extends Node

# Procedural Styling Generator for Vaporwave NPCs & Aesthetics

const PASTEL_SHIRT_COLORS = [
	Color(0.95, 0.45, 0.70, 1.0), # Hot Pink
	Color(0.35, 0.85, 0.95, 1.0), # Neon Cyan
	Color(0.75, 0.55, 0.95, 1.0), # Pastel Lavender
	Color(0.95, 0.85, 0.40, 1.0), # Sunset Gold
	Color(0.40, 0.95, 0.70, 1.0), # Mint Green
	Color(1.00, 0.60, 0.50, 1.0), # Coral Peach
]

const HAIR_COLORS = [
	Color(0.20, 0.10, 0.30, 1.0), # Midnight Indigo
	Color(0.85, 0.20, 0.60, 1.0), # Magenta Glow
	Color(0.15, 0.80, 0.85, 1.0), # Cyan Shock
	Color(0.95, 0.75, 0.30, 1.0), # Blonde Sun
	Color(0.60, 0.25, 0.80, 1.0), # Electric Violet
	Color(0.85, 0.40, 0.20, 1.0), # Sunset Orange
]

const SKIN_TONES = [
	Color(1.00, 0.85, 0.75, 1.0),
	Color(0.95, 0.78, 0.65, 1.0),
	Color(0.82, 0.60, 0.45, 1.0),
	Color(0.60, 0.40, 0.28, 1.0),
	Color(0.42, 0.28, 0.20, 1.0),
	Color(0.85, 0.80, 0.95, 1.0), # Alien vaporwave pastel lilac
]

static func get_random_shirt() -> Color:
	return PASTEL_SHIRT_COLORS[randi() % PASTEL_SHIRT_COLORS.size()]

static func get_random_hair() -> Color:
	return HAIR_COLORS[randi() % HAIR_COLORS.size()]

static func get_random_skin() -> Color:
	return SKIN_TONES[randi() % SKIN_TONES.size()]
