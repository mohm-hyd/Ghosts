class_name InteractableComponent
extends Area2D

signal interacted(player: Player)
signal player_entered_range
signal player_exited_range

@export var prompt_text : String = "Press E to Inspect"

var player_in_range : bool = false
var current_player : Player = null

func _ready() -> void:

	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed(&"interact"): # Map "interact" to key "E" in Input Map
		interact()

func interact() -> void:
	# Emit signal or call whatever UI/clue logic is needed
	interacted.emit(current_player)



func _on_area_entered(area: Area2D) -> void:
	if area.name == "InteractionArea" or area.get_parent() is Player:
		player_in_range = true
		current_player = area.get_parent() as Player
		if not current_player and area.owner is Player:
			current_player = area.owner as Player
			
	player_entered_range.emit()

func _on_area_exited(area: Area2D) -> void:
	if area.name == "InteractionArea" or area.get_parent() is Player:
		player_in_range = false
		player_exited_range.emit()
