extends Resource

class_name Item

@export var id : String
@export var max_amount : int = 99
@export var display_name : String
@export var texture : Texture2D

func _on_select():
	pass

func _on_deselect():
	pass