extends Control

signal start_game
signal quit_game



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	start_game.emit()


func _on_quit_button_pressed() -> void:
	quit_game.emit()
