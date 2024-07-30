extends Node2D

enum TrapState{
	inactive,
	active
}


@onready var DespawnTimer : Timer = $DespawnTimer
@onready var TrapJoint : Joint2D = $Teeth/TrapJoint


var current_state
var trapped : CharacterBody2D
var triggered : bool = false


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
	print_debug(body, " trapped")
	if body.is_in_group("Entity") and not triggered:
		triggered = true
		if body.has_method("trap"): body.trap()
		start_despawn_timer()


func _on_trap_timer_timeout():
	queue_free()
