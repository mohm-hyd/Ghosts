class_name Enemy
extends Node2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@export var required_item_to_survive : String = "HolyAmulet"

func _ready() -> void:
	interactable_component.interacted.connect(_on_interacted)

func _on_interacted(player: Player) -> void:
	var game_state = get_tree().root.find_child("GameStateController", true, false)

	if game_state and game_state.equipped_item_name == required_item_to_survive:
		pass
		# Trigger success / unlock path
	else:
		_kill_player(player)

func _kill_player(player: Player) -> void:
	if player:
		player.can_move = false
		get_tree().reload_current_scene()
