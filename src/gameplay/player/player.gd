class_name Player
extends CharacterBody2D

@onready var interaction_area: Area2D = $InteractionArea
@onready var interaction_prompt: Label = \
	$"../../UI/InteractionPrompt"

var nearby_clue: Area2D = null

func _process(_delta: float) -> void:
	nearby_clue = null

	for area in interaction_area.get_overlapping_areas():
		if area.is_in_group("clue_objects") and area.can_interact():
			nearby_clue = area
			break

	interaction_prompt.visible = nearby_clue != null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearby_clue != null:
		nearby_clue.interact()
		# FUTURE add camera switching logic here
	
		
func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left","move_right")
	velocity.x = direction * 600
	move_and_slide()
	
	if direction <0:
		%Aspen.scale.x = abs(%Aspen.scale.x) 
	elif direction > 0:
		%Aspen.scale.x = -abs(%Aspen.scale.x) 


	if velocity.length() > 0.0:
		%Aspen.play_walk_animation()
	else: 
		%Aspen.play_idle_animation()
