class_name ToggleableObject
extends Node2D

@export var prompt_message: String = "Press E to interact"

var is_open: bool = false

var closed_sprite: Sprite2D = null
var open_sprite: Sprite2D = null
var interactable_component: InteractableComponent = null

func _ready() -> void:
	if interactable_component:
		interactable_component.interacted.connect(_on_container_interacted)
	
	update_visuals()
	_update_contents()

func _on_container_interacted(_player: Player) -> void:
	if is_open:
		if _has_active_contents():
			return 
		close()
	else:
		open()

func open() -> void:
	is_open = true
	update_visuals()
	_update_contents()

func close() -> void:
	is_open = false
	update_visuals()
	_update_contents()

func update_visuals() -> void:
	if closed_sprite and open_sprite:
		closed_sprite.visible = !is_open
		open_sprite.visible = is_open

func _update_contents() -> void:
	for child in get_children():
		if child.has_method("set_container_accessible"):
			child.set_container_accessible(is_open)
		for subchild in child.get_children():
			if subchild.has_method("set_container_accessible"):
				subchild.set_container_accessible(is_open)

func _has_active_contents() -> bool:
	for child in get_children():
		if child.has_method("has_active_item") and child.has_active_item():
			return true
		for subchild in child.get_children():
			if subchild.has_method("has_active_item") and subchild.has_active_item():
				return true
	return false
