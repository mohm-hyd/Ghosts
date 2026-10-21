class_name GhostEntity
extends Node2D

@export var ghost_name: String = "Ghost"
@export var required_item_to_survive: String = "HolyAmulet"
@export var ghost_dialogue: Array[DE] # Optional dialogue when interacting with the right item

@onready var sprite: Sprite2D = $Sprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var reveal_component: GhostVisionRevealComponent = $GhostVisionRevealComponent

var is_ghost_vision_active: bool = false
var is_resolved: bool = false

func _ready() -> void:
	add_to_group("clue_objects")
	if interactable_component:
		interactable_component.prompt_text = "Press E to confront " + ghost_name
		interactable_component.interacted.connect(_on_interacted)
	
	# Start hidden and disabled until ghost vision reveals them
	_update_ghost_visibility(false)

# Called automatically by VisionStateController via the "clue_objects" group
func set_ghost_vision_active(active: bool) -> void:
	is_ghost_vision_active = active
	_update_ghost_visibility(active)

func _update_ghost_visibility(active: bool) -> void:
	var visible_state = active and not is_resolved
	
	if sprite:
		sprite.visible = visible_state
		
	if interactable_component:
		interactable_component.set_deferred("monitoring", visible_state)
		interactable_component.set_deferred("monitorable", visible_state)
		
		var col = interactable_component.get_node_or_null("CollisionShape2D")
		if col:
			col.set_deferred("disabled", not visible_state)

func _on_interacted(player: Player) -> void:
	if not is_ghost_vision_active or is_resolved:
		return

	# Check what item the player currently has equipped/selected
	var game_state = get_tree().root.find_child("GameStateController", true, false)
	var equipped_item = game_state.equipped_item_name if game_state else ""

	if equipped_item == required_item_to_survive:
		_on_survival_success(player)
	else:
		_kill_player(player)

func _on_survival_success(player: Player) -> void:
	is_resolved = true
	_update_ghost_visibility(false)
	print(ghost_name + " pacified/satisfied successfully!")
	# Optional: Trigger success dialogue or unlock path here

func _kill_player(player: Player) -> void:
	print(ghost_name + " killed the player due to wrong item: " + required_item_to_survive)
	if player:
		player.can_move = false
	get_tree().reload_current_scene()
