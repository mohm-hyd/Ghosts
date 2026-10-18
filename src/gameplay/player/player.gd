class_name Player
extends CharacterBody2D




func _process(_delta: float) -> void:
	pass

	
		

const SPEED : float = 600.0

var camera_look_direction : Vector2 = Vector2.ZERO

@onready var player_sprite = %Aspen

func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_axis(&"move_left", &"move_right")


	velocity.x = input_direction * SPEED 


	if velocity.length() > 0.0:
		player_sprite.play_walk_animation()
	else: 
		player_sprite.play_idle_animation()
		 
	_handle_horizontal_flip()

	move_and_slide()

func _handle_horizontal_flip() -> void:
	if absf(velocity.x) > 0.1:
		player_sprite.scale.x = abs(player_sprite.scale.x) if (velocity.x < 0.0 ) else -abs(player_sprite.scale.x)
