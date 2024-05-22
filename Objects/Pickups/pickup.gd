extends Area2D

class_name Pickup

@export var item : Item
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var launch_velocity : Vector2 = Vector2.ZERO
var move_duration : float = 0
var time_since_launch : float = 0
var launching : bool = false :
	set(is_launching):
		launching = is_launching
		
		set_deferred("collision_shape.disabled", launching)

func _ready():
	connect("body_entered", _on_body_entered)

func _process(delta):
	# Move the pickup only after a launch, not every pickup spawns in this way
	# but all have the ability to
	if(launching):
		position += launch_velocity * delta
		time_since_launch += delta
		
		if(time_since_launch >= move_duration):
			launching = false

# Moves the pickup in a direction for an amount of time before enabling
# the pickup to actually be picked up
func launch(velocity : Vector2, duration : float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true

func _on_body_entered(body : Node2D):
	if(body.name == "Player"):	
		var inventory = GameManager.inventory
	
		if(inventory):
			var amount_to_add = 1
			var overflow = inventory.add_resources(item, amount_to_add)
			if(overflow == 0):
				queue_free()
