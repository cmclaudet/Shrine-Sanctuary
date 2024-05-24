extends BuildingRule

class_name SpendResourcesBuildingRule

@export var resource_stacks_to_spend : Array[InventorySlot] = []

var _bus : BuildingSignalBus


func setup(params : RuleValidationParameters) -> bool:
	if(not _pre_setup_validation(params)): return false
	_bus = params.building_signal_bus
	_bus.connect("object_placed", _on_object_placed)
	return _post_setup_validation()

func tear_down():
	if(_bus != null):
		_bus.disconnect("object_placed", _on_object_placed)
		_bus = null

## Checks to see if there are enough resources to build item
func validate_condition() -> RuleResult:
	var missing_resources_stacks : Array[InventorySlot] = check_missing_resources()
	
	if(missing_resources_stacks.size() > 0):
		var failed_message : String = "Not Enough Materials: "
		
		# Needs to set resource names for them to show up in the string
		for missing_stack in missing_resources_stacks:
			if(missing_stack.item == null):
				push_error("Missing a null resource item of count " + str(missing_stack.amount))
				continue
			
			failed_message += "\n" + missing_stack.item.id + " : " + str(missing_stack.amount)
		
		return RuleResult.new(false, failed_message)
	else:
		return RuleResult.new(true, "All expected spend resource requirements met.")
			
func _on_object_placed(p_placer : Node, p_placed : Node2D):
	_spend_resources()
	
## Remove resources from the target inventory
## Returns if all resources spent successfully or not
func _spend_resources() -> bool:
	for slot in resource_stacks_to_spend:
		var amount_not_removed = GameManager.inventory.remove_resources(slot.item, slot.amount)
		if(amount_not_removed == 0):
			return true
		else:
			push_error("Expected to spend " + str(slot.amount) + " of type [" + slot.item.id + "] but actually spent " + str(slot.amount - amount_not_removed))
			return false
	
	return false
	
## Checks the resouce _spender_container to see if it has enough of each resource type
## Returns ItemStacks that contain the amount missing for each type
func check_missing_resources() -> Array[InventorySlot]:
	var missing_resources : Array[InventorySlot] = []
	
	for slot in resource_stacks_to_spend:
		var had_count : int = GameManager.inventory.get_resource_count(slot.item)
		
		if(had_count < slot.amount):
			var missing_count = slot.amount - had_count
			var missing_stack = InventorySlot.new()

			missing_stack.item = slot.item
			missing_stack.amount = missing_count

			missing_resources.append(missing_stack)
			
	return missing_resources
	
func _pre_setup_validation(params : RuleValidationParameters) -> bool:
	var no_problems = true
	
	if(resource_stacks_to_spend == null):
		push_error("Materials to Spend is not defined in rule")
		no_problems = false
	
	if(resource_stacks_to_spend.size() == 0):
		push_error("No materials to spend set in array for rule")
		no_problems = false
		
	if(params.building_signal_bus == null):
		push_error("No signal bus in params to receive placement callback")
		no_problems = false
		
	for slot in resource_stacks_to_spend:
		if(slot.item == null):
			push_warning("Spend resource item is null")
			no_problems = false
		
	return no_problems

func _post_setup_validation() -> bool:
	var no_problems = true
		
	if(_bus == null):
		push_error("No bus set in rule")
		no_problems = false
	elif(not _bus.is_connected("object_placed", _on_object_placed)):
		push_error("On object placed is not connected to bus " + _bus.resource_path)
		no_problems = false
	
	return no_problems
