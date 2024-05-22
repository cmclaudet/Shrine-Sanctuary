@tool
extends Sprite2D

class_name HandEquip

signal on_tool_contact_signal(equipped_item : EquipableItem)

@export var equipped_item : EquipableItem :
	set(next_equipped):
		equipped_item = next_equipped
		if(next_equipped != null):
			self.texture = next_equipped.texture
		else:
			self.texture = null

@export var sprite_2d : Sprite2D

func on_equipped_item_contact():
	if(not Engine.is_editor_hint()):
		on_tool_contact_signal.emit(equipped_item)
