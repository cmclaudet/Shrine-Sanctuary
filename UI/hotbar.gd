extends Control

class_name HotBar

@onready var grid_container : GridContainer = $GridContainer

var current_slot_index: int
var item_buttons : Array[ItemButton] = []

func _ready() -> void:
	var inventory_slots : Array[InventorySlot] = []

	for i in range(grid_container.get_children().size()):
		var button = grid_container.get_child(i)
		if(button is ItemButton):
			button.item_button_container = self
			button.hotbar_slot_index = i

			var slot = InventorySlot.new()
			if(button.item != null):
				slot.item = button.item
				var overflow = slot.try_add_amount(button.amount)
				if(overflow > 0):
					print($"Starting amount {button.amount} is too high for item {button.item.display_name}!")
			
			inventory_slots.append(slot)
			item_buttons.append(button)

	GameManager.inventory.init(inventory_slots)
	current_slot_index = 0
	update_button_views()
	get_current_button()._on_pressed()

func get_current_button() -> ItemButton:
	return item_buttons[current_slot_index]

func _on_inventory_resource_count_changed(_item:Item, _amount_added:int) -> void:
	update_button_views()

func update_button_views() -> void:
	var inventory_slots : Array[InventorySlot] = GameManager.inventory.get_slots_range(0, item_buttons.size())
	for i in range(inventory_slots.size()):
		var slot : InventorySlot = inventory_slots[i]
		item_buttons[i].update(slot.item, slot.amount)
