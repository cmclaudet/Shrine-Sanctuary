extends CharacterBody2D

class_name Player

@export var speed : float = 100.0

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var interaction_area2D : InteractionArea2D = $InteractionArea2D
@onready var hand_equip : HandEquip = $HandEquip

var direction : Vector2 = Vector2.ZERO
var can_move : bool = true

func _ready():
	animation_tree.active = true
	
func _process(_delta):
	if(Input.is_action_just_pressed("use")):
		animation_tree["parameters/conditions/swing"] = true
		animation_tree["parameters/conditions/idle"] = false
		can_move = false
		interaction_area2D.interact_start()
	elif (Input.is_action_pressed("use")):
		interaction_area2D.interact_hold()
	elif (Input.is_action_just_released("use")):
		animation_tree["parameters/conditions/swing"] = false
		animation_tree["parameters/conditions/idle"] = true
		can_move = true
		interaction_area2D.interact_end()
	elif(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true

	if(direction != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Swing/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction

func _physics_process(_delta):
	# Move in 4 directions
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	if direction and can_move:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_hand_equip_on_tool_contact_signal(equipped_item: EquipableItem) -> void:
	if(can_harvest_closest_interactable(equipped_item)):
		interaction_area2D.closestInteractable.try_harvest()

func can_harvest_closest_interactable(equipped_item: EquipableItem) -> bool:
	var can_harvest = interaction_area2D.closestInteractable != null \
		and interaction_area2D.closestInteractable is ResourceNode \
		and equipped_item is HarvestingTool

	if(can_harvest):
		return are_node_types_compatible(interaction_area2D.closestInteractable.node_types, equipped_item.effected_types)
	else:
		return false

func are_node_types_compatible(interactable_node_types : Array[ResourceNodeType], item_node_types : Array[ResourceNodeType]) -> bool:
	var canHarvest = false
	for node_type in interactable_node_types:
		if item_node_types.has(node_type):
			canHarvest = true
			break
	return canHarvest