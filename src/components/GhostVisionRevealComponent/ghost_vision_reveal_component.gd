class_name GhostVisionRevealComponent
extends Node2D

@export var highlight_sprite : Sprite2D

var discovered := false

func _ready() -> void:
	add_to_group("clue_objects")
	if highlight_sprite:
		highlight_sprite.visible = false

func set_ghost_vision_active(active: bool) -> void:
	if not highlight_sprite:
		return
		
	highlight_sprite.visible = active

	if active and not discovered:
		discovered = true
		play_discovery_pulse()

func play_discovery_pulse() -> void:
	if not highlight_sprite:
		return
		
	highlight_sprite.scale = Vector2.ONE * 0.5
	highlight_sprite.modulate.a = 1.0

	var tween := create_tween()
	tween.tween_property(
		highlight_sprite,
		"scale",
		Vector2.ONE * 1.4,
		0.25
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		highlight_sprite,
		"scale",
		Vector2.ONE,
		0.15
	)
