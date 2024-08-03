extends RigidBody2D


signal pot_impacted
signal pot_thrown


@export var dmg : int = 50


@onready var current_effect : PackedScene
@onready var hot_bar_buttons : Array = get_tree().get_nodes_in_group("HotbarButtons")


var StatusEffects : PackedScene
var pot_fired : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0
	add_to_group("PotProjectile")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func throw_pot():
	emit_signal("pot_thrown")
	gravity_scale = 1.0
	pot_fired = true
	
	
func determine_effect():
	for hot_bar_button in hot_bar_buttons:
		if hot_bar_button.effect_enabled:
			hot_bar_button.start_cooldown()
			current_effect = hot_bar_button.Ammo
		

func spawn_effect():
	if current_effect:
		var effect_spawn = current_effect.instantiate()
		effect_spawn.global_position = global_position
		get_parent().add_child(effect_spawn)


func _on_area_2d_body_entered(body):
	if body.is_in_group("NoPot") or not pot_fired: return
	if body.has_method("take_damage"): body.take_damage(dmg)
	determine_effect()
	spawn_effect()
	emit_signal("pot_impacted")
	queue_free()
	
