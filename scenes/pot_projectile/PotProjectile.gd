extends RigidBody2D


signal pot_impacted
signal pot_thrown


@export var dmg : int = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0
	add_to_group("PotProjectile")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func throw_pot():
	emit_signal("pot_thrown")
	gravity_scale = 1
	

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"): body.take_damage(dmg)
	emit_signal("pot_impacted")
	queue_free()
