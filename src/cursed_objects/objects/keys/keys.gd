class_name Keys
extends WorldItem

func _ready() -> void:
	super._ready()
	
	set_container_accessible(true)
	
	
func _on_item_interacted(_player: Player) -> void:
		
	var inventory = get_tree().get_first_node_in_group("inventory")
	if inventory and inventory.has_method("add_item"):
		AudioManager.play_pickup_sfx()
		inventory.add_item(self)
		is_collected = true
		queue_free()
		print("Item collected successfully!")
