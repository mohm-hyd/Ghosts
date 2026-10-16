extends Node2D


@onready var highlight: Sprite2D = $Highlight
@onready var clue_ui  = $ClueComponent


var discovered := false
var ghost_vision_active := false

func _ready() -> void:
	add_to_group("clue_objects")
	highlight.visible = false

func set_ghost_vision_active(active: bool) -> void:
	ghost_vision_active = active
	highlight.visible = active

	if active and not discovered:
		discovered = true
		play_discovery_pulse()

func play_discovery_pulse() -> void:
	highlight.scale = Vector2.ONE * 0.5
	highlight.modulate.a = 1.0

	var tween := create_tween()
	tween.tween_property(
		highlight,
		"scale",
		Vector2.ONE * 1.4,
		0.25
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		highlight,
		"scale",
		Vector2.ONE,
		0.15
	)
func can_interact() -> bool:
	return discovered

func interact() -> void:
	if not can_interact():
		return
