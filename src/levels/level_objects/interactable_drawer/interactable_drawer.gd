class_name InspectableDrawer
extends ToggleableObject

@onready var drawer_closed_sprite: Sprite2D = $DrawerClosed
@onready var drawer_open_sprite: Sprite2D = $DrawerOpen
@onready var pickup_object : Node2D = $ChildsDrawing
@onready var item_sprite: Sprite2D = $ChildsDrawing/WorldItem/Sprite2D

var item_collected: bool = false

func _ready() -> void:
	closed_sprite = drawer_closed_sprite
	open_sprite = drawer_open_sprite
	interactable_component = $InteractableComponent
	
	# Let ToggleableObject handle its own _ready() and base signals
	super._ready()
	
	# Connect to the INNER item's interactable component for picking it up (do NOT touch the drawer's component)
	var item_interactable = pickup_object.get_node_or_null("WorldItem/InteractableComponent")
	if item_interactable:
		item_interactable.interacted.connect(_on_item_interacted)
		
	update_visuals()

func update_visuals() -> void:
	super.update_visuals()
	
	# Only show the item sprite if the drawer is open AND we haven't collected it yet
	if item_sprite:
		item_sprite.visible = is_open and not item_collected
		
	# Enable or disable the item's interaction collider depending on whether drawer is open
	var item_interactable = pickup_object.get_node_or_null("WorldItem/InteractableComponent")
	if item_interactable:
		item_interactable.monitoring = is_open and not item_collected
		item_interactable.monitorable = is_open and not item_collected
		var col = item_interactable.get_node_or_null("CollisionShape2D")
		if col:
			col.disabled = not is_open or item_collected

func _on_item_interacted(_player: Player) -> void:
	if is_open and not item_collected:
		var world_item = pickup_object.get_node_or_null("WorldItem") as WorldItem
		if world_item:
			var inventory = get_tree().get_first_node_in_group("inventory")
			if inventory and inventory.has_method("add_item"):
				inventory.add_item(world_item)
				item_collected = true
				if item_sprite:
					item_sprite.visible = false
				print("Item collected from open drawer!")
