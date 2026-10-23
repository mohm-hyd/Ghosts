extends Node2D

signal return_to_main_menu







func _on_return_button_pressed() -> void:
	return_to_main_menu.emit()
