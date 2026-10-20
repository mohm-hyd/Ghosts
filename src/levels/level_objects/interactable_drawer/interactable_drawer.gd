class_name InspectableDrawer
extends ToggleableObject

@onready var drawer_closed_sprite: Sprite2D = $DrawerClosed
@onready var drawer_open_sprite: Sprite2D = $DrawerOpen
@onready var pickup_object : Node = $ChildsDrawing

func _ready() -> void:
	closed_sprite = drawer_closed_sprite
	open_sprite = drawer_open_sprite
	interactable_component = $InteractableComponent
	super._ready()

func update_visuals() -> void:
		if closed_sprite and open_sprite:
			closed_sprite.visible = !is_open
			open_sprite.visible = is_open
		#if is_open:
		#	pickup_object.visible = true
		#else: 
		#	pickup_object.visible = false
		
