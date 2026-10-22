class_name LevelTransition
extends Area2D

@export_file("*.tscn") var target_level_uid : String
@export var target_spawn_name : String = "PlayerSpawn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		var parent_door = get_parent()
		if parent_door and "is_open" in parent_door:
			if not parent_door.is_open:
				return
		
		if target_level_uid.is_empty():
			push_error("LevelTransition has no target level UID assigned!")
			return
			
		var game_state = get_tree().root.find_child("GameStateController", true, false)
		if game_state and game_state.has_method("request_level_transition"):
			game_state.request_level_transition(target_level_uid, target_spawn_name)
		else:
			push_error("LevelTransition could not find GameStateController!")
