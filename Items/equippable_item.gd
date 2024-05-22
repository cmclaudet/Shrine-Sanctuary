extends Item

class_name EquipableItem

func _on_select():
	GameManager.player.hand_equip.equipped_item = self

func _on_deselect():
	GameManager.player.hand_equip.equipped_item = null
