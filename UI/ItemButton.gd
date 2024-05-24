@tool
extends Button

class_name ItemButton

@export var item : Item :
	set(item_to_slot):
		item = item_to_slot
		if(item == null):
			icon = null
		else:
			icon = item.icon

@export var amount_label : Label

@export var amount : int :
	set(new_amount):
		amount = new_amount
		if(amount <= 1):
			amount_label.text = ""
		else:
			amount_label.text = str(amount)

var hand_equip : HandEquip
var hotbar_slot_index : int
var item_button_container : HotBar

func _ready():
	if(not Engine.is_editor_hint()):
		connect("pressed", _on_pressed)
	
func _on_pressed():
	if(not Engine.is_editor_hint()):
		var current_item = item_button_container.get_current_button().item
		if(current_item != null):
			current_item._on_deselect()
		if(item != null):
			item._on_select()
		item_button_container.current_slot_index = hotbar_slot_index

func update(new_item: Item, new_amount: int):
	if(new_amount <= 0):
		item = null
		amount = 0
	else:
		item = new_item
		amount = new_amount