class_name VisionStateController
extends Node2D

var _active_camera : Camera2D = null
var level_camera : PlayerCamera
var ghost_camera :GhostCamera

var is_ghost_vision_on : bool = false

func _process(_delta) -> void:
	_sync_audio_state()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"toggle_ghost_vision"):
		is_ghost_vision_on = !is_ghost_vision_on
		
		if is_ghost_vision_on:
			ghost_camera.set_ghost_vision_active(true)
			activate_camera(ghost_camera)
			view_clue_objects()
			AudioManager.play_ghost_music()
		else:
			ghost_camera.set_ghost_vision_active(false)
			activate_camera(level_camera)
			view_clue_objects()
			AudioManager.play_normal_music()

func _sync_audio_state() -> void:
	if is_ghost_vision_on:
		AudioManager.play_ghost_music()
	else:
		AudioManager.play_normal_music()

func reset_vision() -> void:
	is_ghost_vision_on = false
	if ghost_camera:
		ghost_camera.set_ghost_vision_active(false)
	if level_camera:
		activate_camera(level_camera)
		view_clue_objects()
	AudioManager.play_normal_music()

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
