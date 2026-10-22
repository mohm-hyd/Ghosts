extends Control

const DIALOGUE_BUTTON_PRELOAD = preload("uid://dihmkew2ce3oe")

@onready var dialogue_label : RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var speakerName : Label = $HBoxContainer/SpeakerParent/Label

var dialogue : Array[DE]
var current_dialogue_item : int = 0
var next_item : bool = true

var player_node : Player

func _ready() -> void:
	visible = false
	$HBoxContainer/VBoxContainer/ButtonContainer.visible = false
	
	for i in get_tree().get_nodes_in_group("player") :
		player_node = i
		
func _process(_delta: float) -> void:
	if current_dialogue_item == dialogue.size():
		if !player_node:
			for i in get_tree().get_nodes_in_group("player") :
				player_node = i
			return
		player_node.can_move = true
		queue_free()
		return
	
	if next_item:
		next_item = false
		var i = dialogue[current_dialogue_item]
		
		if i is DialogueFunction:
			if i.hide_dialogue_box:
				visible = true
			else:
				visible = false
			_function_resource(i)
		
		elif i is DialogueChoice :
			visible = true
			_choice_resource(i)
		
		elif i  is DialogueText :
			visible = true
			_text_resource(i)
		
		else:
			push_error("Invalid Dialogue resource")
			current_dialogue_item += 1
			next_item = true
			

func _function_resource(i : DialogueFunction) -> void:
	var target_node = get_node(i.target_path)
	if target_node.has_method(i.function_name):
		if i.function_arguments.size() == 0:
			target_node.call(i.function_name)
		else:
			target_node.callv(i.function_name, i.function_arguments)
		
		if i.wait_for_signal_to_continue:
			var signal_name = i.wait_for_signal_to_continue
			if target_node.has_signal(signal_name):
				var signal_state  = { "done" : false}
				var callable = func(_args) : signal_state.done = true
				target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
				while not signal_state.done:
					await get_tree().process_frame
					
		current_dialogue_item += 1
		next_item = true
	
func _choice_resource(i : DialogueChoice) -> void:
	dialogue_label.text = i.text
	dialogue_label.visible_characters = -1
	 
	if i.speaker_name:
		$HBoxContainer/SpeakerParent.visible = true
		speakerName.text = i.speaker_name
	else:
		$HBoxContainer/SpeakerParent.visible = false
		$HBoxContainer/VBoxContainer/ButtonContainer.visible = true
	
	for item in i.choice_text.size():
		var dialogue_button_scene =  DIALOGUE_BUTTON_PRELOAD.instantiate()
		dialogue_button_scene.text = i.choice_text[item]
		
		var function_resource : DialogueFunction = i.choice_function_call[item]
		if function_resource:
			dialogue_button_scene.connect("pressed", 
			Callable(get_node(function_resource .target_path),
			function_resource.function_name).bindv(function_resource.function_arguments), 
			CONNECT_ONE_SHOT)
			if function_resource.hide_dialogue_box:
				dialogue_button_scene.connect("pressed",hide, CONNECT_ONE_SHOT)
			
			dialogue_button_scene.connect("pressed",
			_choice_button_pressed.bind(get_node(function_resource.target_path),
			function_resource.wait_for_signal_to_continue), CONNECT_ONE_SHOT)
		else:
			dialogue_button_scene.connect("pressed", 
			_choice_button_pressed.bind(null,""), CONNECT_ONE_SHOT)
		
		$HBoxContainer/VBoxContainer/ButtonContainer.add_child(dialogue_button_scene)
		
	$HBoxContainer/VBoxContainer/ButtonContainer.get_child(0).grab_focus()

func _choice_button_pressed(target_node: Node, wait_for_signal_to_continue : String) :
	$HBoxContainer/VBoxContainer/ButtonContainer.visible = false
	for i in $HBoxContainer/VBoxContainer/ButtonContainer.get_children():
		i.queue_free()
	
	if wait_for_signal_to_continue:
			var signal_name = wait_for_signal_to_continue
			if target_node.has_signal(signal_name):
				var signal_state  = { "done" : false}
				var callable = func(_args) : signal_state.done = true
				target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
				while not signal_state.done:
					await get_tree().process_frame
	
	current_dialogue_item +=1
	next_item = true

		
		
	
	
func _text_resource(i : DialogueText) -> void:
	speakerName.text = i.speaker_name
	
	
	var camera : Camera2D = get_viewport().get_camera_2d()
	if camera and i.camera_position != Vector2(999.999,999.999):
		var  camera_tween : Tween = create_tween().set_trans(Tween.TRANS_SINE)
		camera_tween.tween_property(camera, "global_position", i.camera_position, i.camera_transition_time)
	
	dialogue_label.visible_characters = 0
	dialogue_label.text = i.text
	var text_without_square_brackets : String = _text_without_square_brackets(i.text)
	var total_characters: int = text_without_square_brackets.length()
	var character_timer : float = 0.0
	
	while dialogue_label.visible_characters < total_characters:
		if Input.is_action_just_pressed("skip_text"):
			dialogue_label.visible_characters = total_characters
			break
		
		character_timer += get_process_delta_time()
		if character_timer >= (1.0 / i.text_speed) or text_without_square_brackets[dialogue_label.visible_characters] == " " :
			var character: String = text_without_square_brackets[dialogue_label.visible_characters]
			dialogue_label.visible_characters += 1
			if character != " ":
				AudioManager.play_text_sfx()
				
			character_timer = 0.0
			
		await get_tree().process_frame
	
	while true:
		await get_tree().process_frame
		if dialogue_label.visible_characters == total_characters:
			if Input.is_action_just_pressed("next_text"):
				current_dialogue_item += 1
				next_item = true

func _text_without_square_brackets(text: String) -> String:
	var result : String = ""
	var inside_bracket : bool = false
	
	for i in text:
		if i == "[": 
			inside_bracket = true
			continue
		if i == "]":
			inside_bracket = false
			continue
		if !inside_bracket:
			result += i
		
	return result
