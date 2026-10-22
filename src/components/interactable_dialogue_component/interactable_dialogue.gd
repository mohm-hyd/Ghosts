class_name InteractableDialogue
extends Node

const DIALOGUE_SYSTEM_PRELOAD = preload("uid://hdkrdoo7lmii") 

@export var prompt_text: String = "Press E to Inspect"
@export var dialogue: Array[DE]
@export var override_dialogue_position: bool = false
@export var override_position: Vector2
@export var only_activate_once: bool = false

@onready var interactable_component: InteractableComponent = get_parent().get_node_or_null("InteractableComponent")

var has_activated_already: bool = false

func _ready() -> void:
	if interactable_component:
		interactable_component.prompt_text = prompt_text
		interactable_component.interacted.connect(_on_interacted)

func _on_interacted(player: Player) -> void:
	if only_activate_once and has_activated_already:
		return
		
	has_activated_already = true
	
	if player:
		player.can_move = false
		
	var new_dialogue = DIALOGUE_SYSTEM_PRELOAD.instantiate()

	if override_dialogue_position:
		new_dialogue.global_position = override_position
		
	new_dialogue.dialogue = dialogue
	get_tree().root.add_child(new_dialogue)
	
	if only_activate_once and interactable_component:
		interactable_component.queue_free()
