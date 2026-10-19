extends DE
class_name DialogueText

@export var speaker_name : String

@export_multiline var text : String
@export_range(0.1,30.0,0.1) var text_speed : float = 18.0


@export var camera_position : Vector2 = Vector2(999.999,999.999)
@export_range(0.05,10.0,0.05) var camera_transition_time : float = 1.0
