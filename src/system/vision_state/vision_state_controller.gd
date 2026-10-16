class_name VisionStateController
extends Node2D

var _active_camera : Camera2D = null
var level_camera : PlayerCamera
var ghost_camera :GhostCamera

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"toggle_ghost_vision"):
		ghost_camera.toggle_ghost_vision()
		activate_camera(ghost_camera)
		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func activate_camera(camera: Camera2D) -> void:
	if camera == null:
		return

	if _active_camera != null \
			and is_instance_valid(_active_camera):
		_active_camera.enabled = false

	_active_camera = camera
	_active_camera.enabled = true
	_active_camera.make_current()
