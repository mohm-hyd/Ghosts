class_name Player
extends CharacterBody2D

const SPEED : float = 600.0

var camera_look_direction : Vector2 = Vector2.ZERO
var can_move :bool = true

@onready var player_sprite = %Aspen

var ghost_kills : int = 0


func _ready() -> void:
	add_to_group("player")

#func _process() -> void:
	


func _physics_process(_delta: float) -> void:
	if !can_move:
		player_sprite.play_idle_animation()
		return
	
	var input_direction = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	
	velocity = input_direction * SPEED 

	if velocity.length() > 0.0:
		player_sprite.play_walk_animation()
	else: 
		player_sprite.play_idle_animation()
		 
	_handle_horizontal_flip()

	move_and_slide()

func _handle_horizontal_flip() -> void:
	if absf(velocity.x) > 0.1:
		player_sprite.scale.x = abs(player_sprite.scale.x) if (velocity.x < 0.0 ) else -abs(player_sprite.scale.x)
