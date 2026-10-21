extends Control
class_name Inventory

const INVENTORY_ITEM_SCENE = preload("uid://dsiuo5ciwurqj")

@export var rows: int = 1
@export var cols: int = 7

@onready var inventory_grid: GridContainer = $GridContainer
@export var inventory_slot_scene = preload("uid://cmlhn4odctb4f")

var slots: Array[InventorySlot]
var equipped_slot_index: int = -1  

func _ready():
	add_to_group("inventory")
	inventory_grid.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	
	for i in range(rows * cols):
		var slot = inventory_slot_scene.instantiate()
		slots.append(slot)
		inventory_grid.add_child(slot)
		slot.slot_input.connect(self._on_slot_input)
		slot.slot_hovered.connect(self._on_slot_hovered)

func _process(_delta):
	var dialogue_box = get_tree().root.find_child("DialogueSystem", true, false)
	visible = (dialogue_box == null)

func _unhandled_input(event: InputEvent) -> void:
	for i in range(7):
		var action_name = "inventory_slot_" + str(i + 1)
		if event.is_action_pressed(action_name):
			_equip_slot_by_index(i)

func _equip_slot_by_index(index: int) -> void:
	if index < slots.size():
		var target_slot = slots[index]
		
		if equipped_slot_index == index:
			equipped_slot_index = -1
			print("Unequipped slot ", index + 1)
		elif not target_slot.is_empty():
			equipped_slot_index = index
			print("Equipped slot ", index + 1, " with: ", target_slot.item.item_name)
		else:
			equipped_slot_index = -1
			print("Slot is empty, nothing to equip.")
			
		_update_slot_visuals()
		_sync_equipped_item_to_game_state()

func _on_slot_input(which: InventorySlot, action: InventorySlot.InventorySlotAction):
	var index = slots.find(which)
	if index != -1:
		_equip_slot_by_index(index)

func _on_slot_hovered(_which: InventorySlot, _is_hovering: bool):
	pass

func _update_slot_visuals() -> void:
	for i in range(slots.size()):
		var slot = slots[i]
		if i == equipped_slot_index:
			slot.modulate = Color(1.3, 1.3, 1.3, 1.0)
		else:
			slot.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _sync_equipped_item_to_game_state() -> void:
	var game_state = get_tree().root.find_child("GameStateController", true, false)
	if game_state and "equipped_item_name" in game_state:
		if equipped_slot_index != -1 and slots[equipped_slot_index].item:
			game_state.equipped_item_name = slots[equipped_slot_index].item.item_name
		else:
			game_state.equipped_item_name = ""
		print("Equipped item updated in GameStateController: ", game_state.equipped_item_name)

func add_item(world_item: WorldItem) -> void:
	var item_data = world_item.get_item_data()
	var _item: InventoryItem = INVENTORY_ITEM_SCENE.instantiate()
	_item.set_data(item_data.item_name, item_data.icon)
	
	for slot in slots:
		if slot.is_empty() and slot.is_respecting_hint(_item):
			slot.item = _item
			slot.update_slot()
			world_item.queue_free()
			return

func retrieve_item(_item_name: String) -> Item:
	for slot in slots:
		if slot.item and slot.item.item_name == _item_name:
			var copy_item := Item.new()
			copy_item.item_name = slot.item.item_name
			copy_item.name = copy_item.item_name
			copy_item.icon = slot.item.icon
			copy_item.is_stackable = slot.item.is_stackable
			slot.remove_item()
			if equipped_slot_index != -1 and slots[equipped_slot_index].is_empty():
				equipped_slot_index = -1
			_update_slot_visuals()
			_sync_equipped_item_to_game_state()
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
	if equipped_slot_index != -1 and slots[equipped_slot_index].is_empty():
		equipped_slot_index = -1
	_update_slot_visuals()
	_sync_equipped_item_to_game_state()

func clear_inventory() -> void:
	for slot in slots:
		slot.remove_item()
	equipped_slot_index = -1
	_update_slot_visuals()
	_sync_equipped_item_to_game_state()
