class_name InspectableLocker
extends Node2D

@onready var locker_closed_sprite: Sprite2D = $LockerClosed
@onready var locker_open_sprite: Sprite2D = $LockerOpen
@onready var interactable_component: InteractableComponent = $InteractableComponent

@export var prompt_message: String = "Press E to open locker"

var is_open: bool = false

func _ready() -> void:
	
	interactable_component.interacted.connect(_on_locker_interacted)
	
	locker_closed_sprite.visible = true
	locker_open_sprite.visible = false

func _on_locker_interacted(_player: Player) -> void:
	if is_open:
		return
		
	open_locker()

func open_locker() -> void:
	is_open = true
	locker_closed_sprite.visible = false
	locker_open_sprite.visible = true
	
