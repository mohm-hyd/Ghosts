extends Control
class_name Inventory

var inventory_item_scene = preload("uid://dsiuo5ciwurqj")

@export var rows: int = 1
@export var cols: int = 7

@onready var inventory_grid: GridContainer = $GridContainer

@export var inventory_slot_scene = preload("uid://cmlhn4odctb4f")
var slots: Array[InventorySlot]

static var selected_item: Item = null


func _ready():
	inventory_grid.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	
	for i in range(rows * cols):
		var slot = inventory_slot_scene.instantiate()
		slots.append(slot)
		inventory_grid.add_child(slot)
		slot.slot_input.connect(self._on_slot_input) 
		slot.slot_hovered.connect(self._on_slot_hovered) 

func _process(delta):
	
	var dialogue_box = get_tree().root.find_child("DialogueSystem", true, false)
	visible = (dialogue_box == null)


func _unhandled_input(event: InputEvent) -> void:
	for i in range(7):
		var action_name = "inventory_slot_" + str(i + 1)
		if event.is_action_pressed(action_name):
			_select_slot_by_index(i)

func _select_slot_by_index(index: int) -> void:
	if index < slots.size():
		var target_slot = slots[index]
		if not target_slot.is_empty():
			if not selected_item:
				selected_item = target_slot.select_item()
			else:
				selected_item = target_slot.deselect_item(selected_item)

func _on_slot_input(which: InventorySlot, action: InventorySlot.InventorySlotAction):
	print(action)
	if not selected_item:
		if action == InventorySlot.InventorySlotAction.SELECT:
			selected_item = which.select_item()
		elif action == InventorySlot.InventorySlotAction.SPLIT:
			selected_item = which.split_item()
	else:
		selected_item = which.deselect_item(selected_item)

func _on_slot_hovered(which: InventorySlot, is_hovering: bool):
	if which.item:
		pass
	elif which.hint_item:
		pass






func add_item(item: Item, amount: int) -> void:
	var _item: InventoryItem = inventory_item_scene.instantiate()
	_item.set_data(
		item.item_name, item.icon, item.is_stackable, amount
	)
	item.queue_free()
	if item.is_stackable:
		for slot in slots:
			if slot.item and slot.item.item_name == _item.item_name:
				slot.item.amount += _item.amount
				return
	for slot in slots:
		if slot.item == null and slot.is_respecting_hint(_item):
			slot.item = _item
			slot.update_slot()
			return



func retrieve_item(_item_name: String) -> Item:
	for slot in slots:
		if slot.item and slot.item.item_name == _item_name:
			var copy_item := Item.new()
			copy_item.item_name = slot.item.item_name
			copy_item.name = copy_item.item_name
			copy_item.icon = slot.item.icon
			copy_item.is_stackable = slot.item.is_stackable
			if slot.item.amount > 1:
				slot.item.amount -= 1
			else:
				slot.remove_item()
			return copy_item
	return null



func all_items() -> Array[Item]:
	var items: Array[Item] = []
	for slot in slots:
		if slot.item:
			items.append(slot.item)
	return items



func all(_name: String) -> Array[Item]:
	var items: Array[Item] = []
	for slot in slots:
		if slot.item and slot.item.item_name == _name:
			items.append(slot.item)
	return items


func remove_all(_name: String) -> void:
	for slot in slots:
		if slot.item and slot.item.item_name == _name:
			slot.remove_item()

func clear_inventory() -> void:
	for slot in slots:
		slot.remove_item()
