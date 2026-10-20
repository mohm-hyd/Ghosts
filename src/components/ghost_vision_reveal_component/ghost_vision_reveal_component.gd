class_name GhostVisionRevealComponent
extends Node2D

@export var highlight_sprite: Sprite2D
@onready var gpu_particles : GPUParticles2D = $"../HighlightComponent"

var pulsing : bool = false
var discovered : bool = false


func _ready() -> void:
	add_to_group("clue_objects")
	if gpu_particles:
		gpu_particles.emitting= false

func set_ghost_vision_active(active: bool) -> void:
	if highlight_sprite:
		highlight_sprite.visible = active
		discovered = active
	if gpu_particles:
		gpu_particles.emitting = active
		
		
		
func _process(delta: float) -> void:
	if discovered:
		pulsing = true
		play_discovery_pulse()
	else :
		pulsing = false
		

func play_discovery_pulse() -> void:
	while pulsing:
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
