class_name GameStateController
extends Node2D

signal game_started
signal game_paused
signal game_resumed
signal returned_to_main_menu
signal game_quit

var in_game : bool = false
var is_paused : bool = false

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed(&"pause") and in_game:
		if is_paused:
			resume_game()
		else:
			pause_game()

func start_game() -> void:
	in_game = true
	is_paused = false
	get_tree().paused = false
	game_started.emit()

func pause_game() -> void:
	if not in_game:
		return
	is_paused = true
	get_tree().paused = true
	game_paused.emit()

func resume_game() -> void:
	is_paused = false
	get_tree().paused = false
	game_resumed.emit()

func return_to_main_menu() -> void:
	in_game = false
	is_paused = false
	get_tree().paused = false
	returned_to_main_menu.emit()

func quit_game() -> void:
	get_tree().paused = false
	game_quit.emit()
