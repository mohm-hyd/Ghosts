class_name SceneTransition
extends CanvasLayer

signal faded_to_black

@onready var color_rect: ColorRect = $ColorRect

@export var fade_duration: float = 0.7

func fade_in() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "modulate:a", 1.0, fade_duration)
	await tween.finished
	faded_to_black.emit()

func fade_out() -> void:
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	await tween.finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_free() 
