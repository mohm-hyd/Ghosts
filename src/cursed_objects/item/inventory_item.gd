extends Item
class_name InventoryItem


@onready var sprite: Sprite2D =$Sprite2D
@onready var label: Label = $Label



func set_data(_name: String, _icon: Texture2D,):
	self.item_name = _name
	self.name = _name
	self.icon = _icon



func _process(delta):
	self.sprite.texture = self.icon
	self.set_sprite_size_to(sprite, Vector2(42, 42))

	label.visible = false



func set_sprite_size_to(sprite: Sprite2D, size: Vector2):
	var texture_size = sprite.texture.get_size()
	var scale_factor = Vector2(size.x / texture_size.x, size.y / texture_size.y)
	sprite.scale = scale_factor



func fade():
	self.sprite.modulate = Color(1, 1, 1, 0.4)
	self.label.modulate = Color(1, 1, 1, 0.4)
