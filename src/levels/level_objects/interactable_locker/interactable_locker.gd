class_name InspectableLocker
extends ToggleableObject

@onready var locker_closed_sprite: Sprite2D = $LockerClosed
@onready var locker_open_sprite: Sprite2D = $LockerOpen

func _ready() -> void:
	closed_sprite = locker_closed_sprite
	open_sprite = locker_open_sprite
	interactable_component = $InteractableComponent
	super._ready() 
