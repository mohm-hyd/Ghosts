class_name WorldItem
extends Node2D

@export var item_name : String = "Item"
@export var icon : Texture2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var interactable_component : InteractableComponent = $InteractableComponent
@onready var interact_prompt : Label = $InteractableComponent/InteractLabel

var is_collected: bool = false
var is_accessible: bool = false

func _ready() -> void:
	if sprite and icon:
		sprite.texture = icon
	if interactable_component:
		interactable_component.prompt_text = "Press E to pick up " + item_name
		interactable_component.interacted.connect(_on_item_interacted)
		
	set_container_accessible(false)

func set_container_accessible(container_is_open: bool) -> void:
	is_accessible = container_is_open and not is_collected
	if sprite:
		sprite.visible = is_accessible
	if interact_prompt:
		interact_prompt.visible = is_accessible
	
	if interactable_component:
		interactable_component.monitoring = is_accessible
		interactable_component.monitorable = is_accessible
		var col = interactable_component.get_node_or_null("CollisionShape2D")
		if col:
			col.disabled = not is_accessible

func has_active_item() -> bool:
	return not is_collected

func _on_item_interacted(_player: Player) -> void:
	if not is_accessible or is_collected:
		return
		
	var inventory = get_tree().get_first_node_in_group("inventory")
	if inventory and inventory.has_method("add_item"):
		AudioManager.play_pickup_sfx()
		inventory.add_item(self)
		is_collected = true
		set_container_accessible(false)
		queue_free()
		print("Item collected successfully!")

func get_item_data() -> Dictionary:
	return {
		"item_name": item_name,
		"icon": icon,
	}
