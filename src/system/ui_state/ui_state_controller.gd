class_name UiStateController
extends Node2D

const MAIN_MENU = null
const PAUSE_SCREEN = preload("uid://37s110v2h0ue")


@onready var hud_root : Control = %HudRoot
@onready var pause_root : Control = %PauseRoot
@onready var game_state = $"../GameStateController"

var active_hud: Node = null
var active_pause_menu: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not game_state.pauseGame.is_connected(_on_pause_game):
		game_state.pauseGame.connect(_on_pause_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pause_game():
	_toggle_pause_menu()
	
func _toggle_pause_menu() ->void:
	if active_pause_menu:
		active_pause_menu.queue_free()
		active_pause_menu= null
		get_tree().paused = false
	else:
		active_pause_menu = PAUSE_SCREEN.instantiate()
		pause_root.add_child(active_pause_menu)
		get_tree().paused = true
	
	
	
