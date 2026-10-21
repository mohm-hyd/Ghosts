class_name GhostVisionRevealComponent
extends Node2D

@export var highlight_sprite: Sprite2D
@onready var gpu_particles : GPUParticles2D = $"../HighlightComponent"

var pulse_tween: Tween = null

func _ready() -> void:
	add_to_group("clue_objects")
	if gpu_particles:
		gpu_particles.emitting = false

func set_ghost_vision_active(active: bool) -> void:
	if active:
		if gpu_particles:
			gpu_particles.emitting = true
		start_pulsing()
	else:
		if gpu_particles:
			gpu_particles.emitting = false
		stop_pulsing()

func start_pulsing() -> void:
	if pulse_tween and pulse_tween.is_valid():
		return
	if not highlight_sprite:
		return

	highlight_sprite.scale = Vector2.ONE
	highlight_sprite.modulate.a = 1.0

	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(
		highlight_sprite, "scale", Vector2.ONE * 1.4, 0.4
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse_tween.tween_property(
		highlight_sprite, "scale", Vector2.ONE * 1.0, 0.4
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_pulsing() -> void:
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
		pulse_tween = null
	if highlight_sprite:
		highlight_sprite.scale = Vector2.ONE
