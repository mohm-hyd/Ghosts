class_name HallwayGhost
extends GhostEntity

@onready var animation_player: AnimationPlayer 

func _ready() -> void:
	super._ready() 
	play_idle_animation()

	
func play_idle_animation() -> void:
	if animation_player and animation_player.has_animation("idle"):
		animation_player.play("idle")
