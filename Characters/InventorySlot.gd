class_name InventorySlot

var item : Item
var amount : int

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
