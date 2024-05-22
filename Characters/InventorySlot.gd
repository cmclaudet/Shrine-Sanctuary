class_name InventorySlot

var item : Item
var amount : int

# Returns the overflow
func try_add_amount(added_amount : int) -> int:
	var new_total = amount + added_amount
	if new_total > item.max_amount:
		var overflow = new_total - item.max_amount
		amount = item.max_amount
		return overflow
	else:
		amount = new_total
		return 0
