extends Node2D


@onready var BearTrapEffectScene : PackedScene = preload("res://scenes/bear_trap/bear_trap.tscn")
@onready var bear_trap_spawn_position : Vector2


var spawn_radius : int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	var PotProjectile : RigidBody2D = get_tree().get_first_node_in_group("Pot")
	var new_bear_trap = BearTrapEffectScene.instantiate()
	new_bear_trap.position = PotProjectile.position
	get_parent().add_child(new_bear_trap)
	var spawned_trap = get_tree().get_nodes_in_group("BearTrap")[-1]
	spawned_trap.Ball.apply_impulse((Vector2(5,-10) / 15 * position))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

 
func set_random_spawn_pos():
	var x_upper_limit : int = -1 #So effect won't spawn underground
	var x : int = generate_random_coordinate(x_upper_limit)
	var y : int = generate_random_coordinate()
	return Vector2(x, y)


func generate_random_coordinate(upper = spawn_radius):
	randomize()
	var lower : int = -upper
	var coordinate : int = randi_range (lower, upper)
	return coordinate
