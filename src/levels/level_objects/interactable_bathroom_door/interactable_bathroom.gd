class_name InteractableBathroom
extends ToggleableObject

@onready var door_closed_sprite: Sprite2D = $BathroomDoorClosed
@onready var door_open_sprite: Sprite2D = $BathroomDoorOpen

signal door_is_open 

func _ready() -> void:
	closed_sprite = door_closed_sprite
	open_sprite = door_open_sprite
	interactable_component = $InteractableComponent
	super._ready()
