extends Node

class_name Inventory

@export var max_slots : int = 40

var inventory_slots : Array[InventorySlot] = []

signal resource_count_changed(item : Item, successfully_added : int)

func init(starting_slots: Array[InventorySlot]) -> void:
	inventory_slots = starting_slots

func get_slots_range(start : int, count: int) -> Array[InventorySlot]:
	return inventory_slots.slice(start, start + count)

# Returns the amount of overflow
func add_resources(item : Item, amount : int) -> int:
	print("add resources: " + str(amount) + " " + item.id)
	var amount_to_add : int = amount
	for slot in inventory_slots:
		if(slot.item == null):
			continue
		if(slot.item.id != item.id):
			continue
		amount_to_add = slot.try_add_amount(amount_to_add)
		if(amount_to_add == 0):
			break
			
	if(amount_to_add > 0):
		for slot in inventory_slots:
			if(slot.item == null):
				slot.item = item
				amount_to_add = slot.try_add_amount(amount_to_add)
				if(amount_to_add == 0):
					break

	if amount_to_add > 0:
		print("Could not add all resources to inventory, remaining: " + str(amount_to_add) + " " + item.id)

	var successfully_added = amount - amount_to_add

	emit_signal("resource_count_changed", item, successfully_added)
	return amount_to_add
