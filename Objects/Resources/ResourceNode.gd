extends InteractiveNode

class_name ResourceNode

@export var node_types : Array[ResourceNodeType]
@export var min_resources : int = 1
@export var max_resources : int = 2
@export var durability : int = 3
@export var pickup_type : PackedScene
@export var depleted_effect : PackedScene
@export var launch_speed : float = 100
@export var launch_duration : float = 0.25

@onready var level_parent = get_parent()

var is_harvesting = false

var current_durability : int :
	set(new_durability):
		current_durability = new_durability
		
		# A resource node with no durability is destroyed and its resources are dropped
		if(current_durability <= 0):
			# spawn particle effect before removing the node
			var effect_instance : GPUParticles2D = depleted_effect.instantiate()
			effect_instance.position = position
			level_parent.add_child(effect_instance)
			effect_instance.emitting = true
			spawn_resource()
			queue_free()

func _ready():
	current_durability = durability

func _on_interact_enter():
	print_debug("Highlight on")

func _on_interact_exit():
	print_debug("Highlight off")

func _on_interact_start():
	if not is_harvesting:
		is_harvesting = true

func _on_interact_end():
	is_harvesting = false

func try_harvest():
	if is_harvesting:
		harvest(1)

func harvest(amount : int):
	print_debug("Harvested " + str(amount) + " resources")
	current_durability -= amount

func spawn_resource():
	var resource_count : int = randi_range(min_resources, max_resources)

	for i in range(resource_count):
		spawn_pickup()

func spawn_pickup():
	var pickup_instance : Pickup = pickup_type.instantiate() as Pickup
	level_parent.call_deferred("add_child", pickup_instance)
	pickup_instance.position = position
	
	var direction : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	
	pickup_instance.launch(direction * launch_speed, launch_duration)