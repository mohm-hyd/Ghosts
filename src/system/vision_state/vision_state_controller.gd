class_name VisionStateController
extends Node2D

var _active_camera : Camera2D = null
var level_camera : PlayerCamera
var ghost_camera :GhostCamera

var is_ghost_vision_on : bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"toggle_ghost_vision"):
		is_ghost_vision_on = !is_ghost_vision_on
		
		if is_ghost_vision_on:
			ghost_camera.set_ghost_vision_active(true)
			activate_camera(ghost_camera)
			view_clue_objects()
		else:
			ghost_camera.set_ghost_vision_active(false)
			activate_camera(level_camera)

func activate_camera(camera: Camera2D) -> void:
	if camera == null:
		return
	
	if _active_camera != null and is_instance_valid(_active_camera):
		_active_camera.enabled = false
	
	_active_camera = camera
	_active_camera.enabled = true
	_active_camera.make_current()

func view_clue_objects() -> void:
	for clue in get_tree().get_nodes_in_group("clue_objects"):
				if clue.has_method("set_ghost_vision_active"):
					clue.set_ghost_vision_active(is_ghost_vision_on)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
