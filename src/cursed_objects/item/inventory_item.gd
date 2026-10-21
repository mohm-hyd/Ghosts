class_name InventoryItem
extends Item

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

const DESIRED_ICON_SIZE = Vector2(140, 140) # Target bounding size inside the slot

func _ready() -> void:
	super._ready()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	if icon and sprite:
		sprite.texture = icon
		_scale_and_center_sprite()

func set_data(_name: String, _icon: Texture2D) -> void:
	self.item_name = _name
	self.name = _name
	self.icon = _icon
	if sprite:
		sprite.texture = _icon
		_scale_and_center_sprite()

func _scale_and_center_sprite() -> void:
	if not sprite or not sprite.texture:
		return
	
	var texture_size = sprite.texture.get_size()
	if texture_size.length() > 0:
		var scale_factor = min(DESIRED_ICON_SIZE.x / texture_size.x, DESIRED_ICON_SIZE.y / texture_size.y)
		sprite.scale = Vector2(scale_factor, scale_factor)
		
	sprite.position = size / 2.0

func fade() -> void:
	if sprite:
		sprite.modulate = Color(1, 1, 1, 0.4)
	if label:
		label.modulate = Color(1, 1, 1, 0.4)
