extends Resource

class_name InventorySlot

@export var item : Item
@export var amount : int

# Returns the overflow
func try_add_amount(added_amount : int) -> int:
	var new_total = amount + added_amount
	if new_total > item.stack_maximum:
		var overflow = new_total - item.stack_maximum
		amount = item.stack_maximum
		return overflow
	else:
		amount = new_total
		return 0

# Returns amount that could not be removed
func try_remove_amount(removed_amount : int) -> int:
	var new_total = amount - removed_amount
	if new_total < 0:
		var overflow = -new_total
		amount = 0
		return overflow
	else:
		amount = new_total
		return 0