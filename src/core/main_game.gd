class_name MainGame
extends Node

const TUTORIAL_BEDROOM_SCENE_UID : String="uid://d1wycq0ylykwr"
const PLAYER_SCENE_UID: String = "uid://ckudr8chj1kgo"
const SCENE_TRANSITION : PackedScene = preload("uid://cy18gylahgif")


@onready var vision_state_controller: Node2D = $System/VisionStateController
@onready var game_state_controller: GameStateController = $System/GameStateController

@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot

var player : Player = null
var _current_level : BaseLevel
var next_spawn_marker_name : String = "PlayerSpawn"
var is_transitioning : bool = false

func _ready() -> void:
	if game_state_controller:
		game_state_controller.game_started.connect(_on_game_started)
		game_state_controller.game_quit.connect(_on_game_quit)
		game_state_controller.level_transition_requested.connect(_on_level_transition_requested)
		game_state_controller.returned_to_main_menu.connect(_on_returned_to_main_menu)
		
func _on_game_started() -> void:
	load_level(TUTORIAL_BEDROOM_SCENE_UID)
	_init_player()

func _on_game_quit() -> void:
	quit_game()

	
func _on_level_transition_requested(level_uid: String, spawn_name: String) -> void:
	next_spawn_marker_name = spawn_name
	load_level(level_uid)
	
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
	player.hide()

func load_level(local_scene : String) -> void:
	_deferred_load_room.call_deferred(local_scene)
	vision_state_controller.reset_vision()
	
func  quit_game() -> void:
	get_tree().quit()

func _on_returned_to_main_menu() -> void:

	if _current_level != null:
		_current_level.queue_free()
		_current_level = null
		

	if player != null:
		player.queue_free()
		player = null
		
	is_transitioning = false
	
func _unhandled_input(event :InputEvent) -> void:
	if event.is_action_pressed(&"debug_quit"):
		quit_game()
		
func _deferred_load_room(level_scene_uid : String) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	
	var transition = SCENE_TRANSITION.instantiate() as SceneTransition
	transition_root.add_child(transition)
	
	await transition.fade_in()
	
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null
		await get_tree().process_frame
	
	var new_level_packed : PackedScene =\
		ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	if new_level_packed == null:
		push_error("Could not load level as a packed scene : " + level_scene_uid)
		transition.fade_out()
		is_transitioning = false
		return
	
	var new_level : Node = new_level_packed.instantiate()
	if not new_level:
		push_error("Could not instantiate new level " + level_scene_uid)
		transition.fade_out()
		is_transitioning = false
		return
	
	if not new_level is BaseLevel:
		new_level.free()
		push_error("Loaded level is not of type BaseLevel" + level_scene_uid)
		transition.fade_out()
		is_transitioning = false
		return
	
	_current_level = new_level as BaseLevel
	level_root.add_child(_current_level)
	
	_place_player_at_level_spawn()
	_setup_level_cameras()
	
	await get_tree().process_frame
	
	await transition.fade_out()
	is_transitioning = false
	
func _place_player_at_level_spawn()->void:
	if player == null:
		push_error("Can not place player in level  because it is null")
		return
	if _current_level == null:
		push_error("Can not place player into level because level is null")
		return
	
	var spawn_node = _current_level.find_child(next_spawn_marker_name, true, false)
	if spawn_node and spawn_node is Marker2D:
		player.global_position = spawn_node.global_position
		player.show()
	else:
		player.global_position = _current_level.get_default_player_spawn()
	
	
func _setup_level_cameras() -> void:
	if player == null or _current_level == null:
		return
		
	var level_camera = _current_level.get_player_camera()
	var ghost_camera = _current_level.get_ghost_vision_camera()

	if level_camera == null or ghost_camera == null:
		push_error("Level is missing a required camera")
		return
		
	level_camera.target = player
	ghost_camera.target = player

	level_camera.enabled = false
	ghost_camera.enabled = false

	vision_state_controller.activate_camera(level_camera)
	vision_state_controller.level_camera = level_camera
	vision_state_controller.ghost_camera = ghost_camera
