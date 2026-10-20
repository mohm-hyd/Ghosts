class_name InspectableClassroomDoor
extends ToggleableObject

@onready var door_closed_sprite: Sprite2D = $DoorClosed
@onready var door_open_sprite: Sprite2D = $DoorOpen

func _ready() -> void:
	closed_sprite = door_closed_sprite
	open_sprite = door_open_sprite
	interactable_component = $InteractableComponent
	super._ready() 
