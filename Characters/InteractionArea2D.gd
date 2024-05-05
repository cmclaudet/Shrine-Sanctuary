extends Area2D

class_name InteractionArea2D

var interactables : Array[InteractiveNode] = []

var closestInteractable : InteractiveNode :
	set(new_interactable):
		if(new_interactable == closestInteractable):
			return
		
		if(closestInteractable != null):
			closestInteractable._on_interact_exit()

		closestInteractable = new_interactable
		if(closestInteractable != null):
			closestInteractable._on_interact_enter()

func _process(_delta: float) -> void:
	var interactableCount = interactables.size()
	if(interactableCount == 0):
		closestInteractable = null
		return

	if(interactableCount == 1):
		closestInteractable = interactables[0]
		return

	var nextClosestInteractable = interactables[0]

	for interactable in interactables:
		if(interactable == nextClosestInteractable):
			continue
		if(interactable.position.distance_to(position) < nextClosestInteractable.position.distance_to(position)):
			nextClosestInteractable = interactable

	if(nextClosestInteractable != closestInteractable):
		closestInteractable = nextClosestInteractable

func interact_start() -> void:
	if closestInteractable != null:
		closestInteractable._on_interact_start()

func interact_hold() -> void:
	if closestInteractable != null:
		closestInteractable._on_interact_hold()

func interact_end() -> void:
	if closestInteractable != null:
		closestInteractable._on_interact_end()

func _on_body_entered(body:Node2D) -> void:
	if(body is InteractiveNode):
		interactables.append(body)

func _on_body_exited(body:Node2D) -> void:
	if(body is InteractiveNode and interactables.has(body)):
		interactables.erase(body)
