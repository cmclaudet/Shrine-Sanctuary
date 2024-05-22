extends Item

class_name PlaceableItem

@export var placeable_resource : ResourceNodeType

func _on_select():
	print("Enter placement mode")

func _on_deselect():
	print("Exit placement mode")