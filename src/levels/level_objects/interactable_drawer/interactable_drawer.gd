class_name InspectableDrawer
extends ToggleableObject

@onready var drawer_closed_sprite: Sprite2D = $DrawerClosed
@onready var drawer_open_sprite: Sprite2D = $DrawerOpen


func _ready() -> void:
	closed_sprite = drawer_closed_sprite
	open_sprite = drawer_open_sprite
	interactable_component = $InteractableComponent
	super._ready()
