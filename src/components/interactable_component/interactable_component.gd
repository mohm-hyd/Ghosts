class_name InteractableComponent
extends Area2D

signal interacted(player: Player)
signal player_entered_range
signal player_exited_range

@export var prompt_text : String = "Press E to Inspect"

var player_in_range : bool = false

func _ready() -> void:
	# Make sure this Area2D detects the player's InteractionArea
	collision_layer = 0
	collision_mask = 2 # Assuming your player's InteractionArea is on layer/mask 2, or adjust as needed
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Alternatively, if using Area2D-to-Area2D detection, connect to area_entered/area_exited instead:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed(&"interact"): # Map "interact" to key "E" in Input Map
		interact()

func interact() -> void:
	# Emit signal or call whatever UI/clue logic is needed
	interacted.emit(null)
	print("Interacted with object!")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		player_entered_range.emit()
		# TODO: Tell HUD to show prompt text

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		player_exited_range.emit()
		# TODO: Tell HUD to hide prompt text

func _on_area_entered(area: Area2D) -> void:
	if area.name == "InteractionArea": # Player's interaction collision area
		player_in_range = true
		player_entered_range.emit()

func _on_area_exited(area: Area2D) -> void:
	if area.name == "InteractionArea":
		player_in_range = false
		player_exited_range.emit()
