class_name GhostCamera
extends Camera2D

@export var transition_duration: float = 0.5

const LERP_WEIGHT : float = 2.0
const CAMERA_LOOK_AHEAD_VAL : Vector2 = Vector2(0.0, -8.0)
const CAMERA_LOOK_AMOUNT    : float =  64.0  

var target : Node2D = null
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

var is_active_vision: bool = false
var current_tween: Tween = null

func _physics_process(delta : float) -> void:
	_follow_camera_target(delta)

func _follow_camera_target(delta : float) -> void:
	if not target:
		return


	var target_camera_offset : Vector2 = CAMERA_LOOK_AHEAD_VAL
	var target_global_pos    : Vector2 = target.global_position + target_camera_offset
	
	target_global_pos += target.camera_look_direction * CAMERA_LOOK_AMOUNT

	var camera_pos_out : Vector2

	camera_pos_out.x = lerpf(global_position.x, target_global_pos.x, LERP_WEIGHT * delta)
	camera_pos_out.y = lerpf(global_position.y, target_global_pos.y, LERP_WEIGHT * delta)

	global_position = camera_pos_out

	
func set_ghost_vision_active(active: bool) -> void:
	is_active_vision = active
	
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	current_tween = create_tween().set_parallel(true)
	
	if active:
		canvas_layer.visible = true
		current_tween.tween_method(
			func(val): color_rect.material.set_shader_parameter("fade_amount", val),
			0.0, 1.0, transition_duration
			)
	else:
		current_tween.tween_method(
			func(val): color_rect.material.set_shader_parameter("fade_amount", val),
			1.0, 0.0, transition_duration
			)
		current_tween.chain().tween_callback(func(): canvas_layer.visible = false)
		
