class_name InspectablePoster
extends ToggleableObject

@onready var poster_closed_sprite: Sprite2D = $Poster
@onready var poster_open_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	closed_sprite = poster_closed_sprite
	open_sprite = poster_open_sprite
	interactable_component = $InteractableComponent
	super._ready() 

func close() -> void:
	pass
