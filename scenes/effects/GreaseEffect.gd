extends Node2D


@onready var GreaseEffectScene : PackedScene = preload("res://scenes/grease/grease.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_grease()


func spawn_grease():
	var PotProjectile : RigidBody2D = get_tree().get_first_node_in_group("Pot")
	var new_grease = GreaseEffectScene.instantiate()
	new_grease.position = PotProjectile.position
	get_parent().add_child(new_grease)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
