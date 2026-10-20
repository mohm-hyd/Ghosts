class_name Item
extends Node

@export var item_name : String = ""
@export var icon: Texture2D

func _ready():
	add_to_group("items")
