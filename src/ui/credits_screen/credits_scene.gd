extends Control


signal return_to_main



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_return_button_pressed() -> void:
	return_to_main.emit()
