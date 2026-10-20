class_name WorldItem
extends Node2D

@export var item_name : String = "Item"
@export var icon : Texture2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var interactable_component : InteractableComponent = $InteractableComponent

var can_interact : bool = false

func _ready() -> void :
	if sprite and icon:
		sprite.texture = icon
	if interactable_component:
		interactable_component.prompt_text = "Press E to pick up" + item_name
		interactable_component.interacted.connect(_on_interacted)
		
func _process(delta: float) -> void:
	if self.visible :
		can_interact = true
	else :
		can_interact = false

func _on_interacted(player : Player)-> void:
	if !can_interact:
		return
	var inventory  = get_tree().get_first_node_in_group("inventory")
	if inventory and inventory.has_method("add_item"):
		inventory.add_item(self)
	else:
		push_error("No inventory found")
	
func get_item_data() -> Dictionary:
	return {
		"item_name":item_name,
		"icon":icon,
	}
