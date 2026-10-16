class_name MainGame
extends Node

const TUTORIAL_BEDROOM_SCENE_UID : String="uid://d1wycq0ylykwr"
const PLAYER_SCENE_UID: String = "uid://ckudr8chj1kgo"

var player : Player = null

var _current_level : BaseLevel
var _active_camera : Camera2D = null

@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot


func _ready() -> void:
	_init_player()
	load_level(TUTORIAL_BEDROOM_SCENE_UID)
	
func _init_player() -> void:
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene " + PLAYER_SCENE_UID)
		return
	
	player = player_scene.instantiate() as Player
	if player == null:
		push_error("Loaded player scene does not extend player : " + PLAYER_SCENE_UID)
		return
	
	entity_root.add_child(player)

func load_level(local_scene : String) -> void:
	_deferred_load_room.call_deferred(local_scene)
func  quit_game() -> void:
	get_tree().root.propogate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _unhandled_input(event :InputEvent) -> void:
	if event.is_action_pressed(&"debug_quit"):
		quit_game()
		
func _deferred_load_room(level_scene_uid : String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null
		await get_tree().process_frame
	
	
	var new_level_packed : PackedScene =\
		ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	if new_level_packed == null:
		push_error("Could not load level as a packed scene : " + level_scene_uid)
		return
	
	var new_level : Node = new_level_packed.instantiate()
	
	if not new_level:
		push_error("Could not instantiate ne level " + level_scene_uid)
		return
	
	if not new_level is BaseLevel:
		new_level.free()
		push_error("Loaded level is not of type BaseLevel" + level_scene_uid)
		return
	
	_current_level = new_level as BaseLevel
	
		# FUTURE (main_menu): should have a fall back scene
	level_root.add_child(_current_level)
	
	_place_player_at_level_spawn()
	_setup_level_cameras()
	
func _place_player_at_level_spawn()->void:
	if player == null:
		push_error("Can not place player in level  because it is null")
		return
	if _current_level == null:
		push_error("Can not place player into level because level is null")
		return
	player.global_position = _current_level.get_default_player_spawn()
	
	
func _setup_level_cameras() -> void:
	if player == null or _current_level == null:
		return

	var level_camera: PlayerCamera = _current_level.get_player_camera()
	var ghost_camera: GhostCamera = _current_level.get_ghost_vision_camera()

	if level_camera == null or ghost_camera == null:
		push_error("Level is missing a required camera")
		return
		
	level_camera.target = player
	ghost_camera.target = player

	level_camera.enabled = false
	ghost_camera.enabled = false

	_activate_camera(level_camera)


func _activate_camera(camera: Camera2D) -> void:
	if camera == null:
		return

	if _active_camera != null \
			and is_instance_valid(_active_camera):
		_active_camera.enabled = false

	_active_camera = camera
	_active_camera.enabled = true
	_active_camera.make_current()
