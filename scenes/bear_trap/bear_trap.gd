extends Node2D

enum TrapState{
	inactive,
	active
}


@onready var DespawnTimer : Timer = $DespawnTimer
@onready var TrapJoint : Joint2D = $Teeth/TrapJoint
@onready var Ball : RigidBody2D = $Ball

var current_state
var trapped : CharacterBody2D
var triggered : bool = false
var dmg = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = TrapState.inactive


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		
		TrapState.inactive:
			pass
		
		TrapState.active:
			pass


func start_despawn_timer():
	DespawnTimer.start()


func _on_trap_area_body_entered(body):
	if not body.is_in_group("Entities") or triggered:
		return
	print_debug(body)
		
	triggered = true
	
	if body.has_method("trap"):
		body.trap()
		var TrapPoint = body.get_path()
		TrapJoint.node_b = TrapPoint
		
	if body.has_method("take_damage"): body.take_damage(dmg)
		
	start_despawn_timer()


func _on_trap_timer_timeout():
	queue_free()
