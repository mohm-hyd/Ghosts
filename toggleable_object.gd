class_name ToggleableObject
extends Node2D

@export var prompt_message: String = "Press E to interact"

var is_open: bool = false

var closed_sprite: Sprite2D = null
var open_sprite: Sprite2D = null
var interactable_component: InteractableComponent = null

func _ready() -> void:
	if interactable_component:
		interactable_component.interacted.connect(_on_interacted)
	
	update_visuals()

func _on_interacted(_player: Player) -> void:
	if is_open:
		close()
	else:
		open()

func open() -> void:
	is_open = true
	update_visuals()

func close() -> void:
	is_open = false
	update_visuals()

func update_visuals() -> void:
	if closed_sprite and open_sprite:
		closed_sprite.visible = !is_open
		open_sprite.visible = is_open
