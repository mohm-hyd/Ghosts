class_name ClassroomLevel
extends BaseLevel

@onready var player_spawn_marker : PlayerSpawn = $Entities/PlayerSpawn
@onready var player_camera :Camera2D = $Entities/PlayerCamera
@onready var ghost_vision_camera : Camera2D = $Entities/GhostVisionCamera



func get_default_player_spawn()-> Vector2:
	return player_spawn_marker.global_position
	
	
func get_player_camera() -> PlayerCamera:
	return player_camera

func get_ghost_vision_camera()-> GhostCamera:
	return ghost_vision_camera
