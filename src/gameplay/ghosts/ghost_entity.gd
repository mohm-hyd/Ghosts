class_name GhostEntity
extends Node2D

const DIALOGUE_SYSTEM_PRELOAD = preload("uid://hdkrdoo7lmii") 

@export var ghost_name: String = "Ghost"
@export var required_item_to_survive: String = "HolyAmulet"
@export var ghost_dialogue: Array[DE] 
@export var reload_level_uid : String
@export var reload_spawn : String

@onready var sprite: Sprite2D = $Sprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_prompt : Label = $InteractableComponent/InteractLabel
@onready var reveal_component: GhostVisionRevealComponent = $GhostVisionRevealComponent

var is_ghost_vision_active: bool = false
var is_resolved: bool = false

func _ready() -> void:
	add_to_group("clue_objects")
	add_to_group("ghosts")
	if interactable_component:
		interactable_component.prompt_text = "Press E to confront " + ghost_name
		interactable_component.interacted.connect(_on_interacted)
	
	_update_ghost_visibility(false)

func set_ghost_vision_active(active: bool) -> void:
	is_ghost_vision_active = active
	_update_ghost_visibility(active)

func _update_ghost_visibility(active: bool) -> void:
	var visible_state = active and not is_resolved
	
	if sprite:
		sprite.visible = visible_state
		interactable_prompt.visible = visible_state
		
	if interactable_component:
		interactable_component.set_deferred("monitoring", visible_state)
		interactable_component.set_deferred("monitorable", visible_state)
		
		var col = interactable_component.get_node_or_null("CollisionShape2D")
		if col:
			col.set_deferred("disabled", not visible_state)

func _on_interacted(player: Player) -> void:
	if not is_ghost_vision_active or is_resolved:
		return


	var game_state = get_tree().root.find_child("GameStateController", true, false)
	var equipped_item = game_state.equipped_item_name if game_state else ""

	if equipped_item == required_item_to_survive:
		_on_survival_success(player)
	else:
		_kill_player(player, reload_level_uid, reload_spawn)

func _on_survival_success(player: Player) -> void:
	#is_resolved = true
	var new_dialogue = DIALOGUE_SYSTEM_PRELOAD.instantiate()
	new_dialogue.dialogue = ghost_dialogue
	get_tree().root.add_child(new_dialogue)
	
	new_dialogue.tree_exited.connect(func():
		is_resolved = true
		_update_ghost_visibility(false)
		queue_free()
		if player:
			player.can_move = true
		print(ghost_name + " despawned automatically when dialogue closed!")
	)
	
	print(ghost_name + " pacified/satisfied successfully!")

func _kill_player(player: Player,level_uid: String, spawn_name: String) -> void:
	print(ghost_name + " killed the player due to wrong item: " + required_item_to_survive)
	var game_state = get_tree().root.find_child("GameStateController", true, false)
	if player:
		player.can_move = false
	game_state.request_level_transition(level_uid, spawn_name)
	
	
