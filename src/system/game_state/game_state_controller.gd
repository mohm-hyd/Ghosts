class_name GameStateController
extends Node2D

signal pauseGame

var in_game : bool = false

func _unhandled_input (event : InputEvent) -> void:
	if event.is_action(&"pause") && in_game:
		pauseGame.emit()
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_game()-> void:
	in_game = true
