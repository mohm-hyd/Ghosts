class_name UiStateController
extends Node2D

const MAIN_MENU = preload("uid://m3enuov566vc")
const PAUSE_SCREEN = preload("uid://37s110v2h0ue")

@onready var hud_root : Control = %HudRoot
@onready var pause_root : Control = %PauseRoot
@onready var game_state = $"../GameStateController"


var active_pause_menu: Node = null
var active_main_menu: Node = null

func _ready() -> void:
	if game_state:
		game_state.game_started.connect(_on_game_started)
		game_state.game_paused.connect(_on_game_paused)
		game_state.game_resumed.connect(_on_game_resumed)
		game_state.returned_to_main_menu.connect(_on_returned_to_main_menu)
	else:
		push_error("UiStateController could not find GameStateController")
	show_main_menu()

func show_main_menu() -> void:
	if not active_main_menu and MAIN_MENU:
		active_main_menu = MAIN_MENU.instantiate()
		hud_root.add_child(active_main_menu)
		if active_main_menu.has_signal("start_game"):
			active_main_menu.start_game.connect(_on_menu_start_pressed)
		if active_main_menu.has_signal("quit_game"):
			active_main_menu.quit_game.connect(_on_menu_quit_pressed)

func _on_menu_start_pressed() -> void:
	if active_main_menu:
		active_main_menu.queue_free()
		active_main_menu = null
		game_state.start_game()

func _on_menu_quit_pressed() -> void:
	game_state.quit_game()

func _on_game_started() -> void:
	if active_main_menu:
		active_main_menu.queue_free()
		active_main_menu = null

func _on_game_paused() -> void:
	if not active_pause_menu and PAUSE_SCREEN:
		active_pause_menu = PAUSE_SCREEN.instantiate()
		pause_root.add_child(active_pause_menu)

func _on_game_resumed() -> void:
	if active_pause_menu:
		active_pause_menu.queue_free()
		active_pause_menu = null

func _on_returned_to_main_menu() -> void:
	if active_pause_menu:
		active_pause_menu.queue_free()
		active_pause_menu = null
	show_main_menu()
	
