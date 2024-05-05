@tool
extends Sprite2D

class_name HandEquip

signal on_tool_contact_signal(equipped_item : EquipableItem)

@export var equipped_item : EquipableItem :
	set(next_equipped):
		equipped_item = next_equipped
		self.texture = next_equipped.texture

@export var sprite_2d : Sprite2D

func on_equipped_item_contact():
	if(not Engine.is_editor_hint()):
		print_debug("Equipped item contact! emitting signal...")
		on_tool_contact_signal.emit(equipped_item)
