extends Node2D


signal cooldown_finished

enum SlingshotState{
	idle,
	ready,
	fired,
	cooldown
}


@onready var DragComponent : Area2D = %DragComponent
@onready var Center : Marker2D = %Center
@onready var FrontPoint : Marker2D = %FrontPoint
@onready var FrontLine : Line2D = %FrontLine
@onready var BackPoint : Marker2D = %BackPoint
@onready var BackLine : Line2D = %BackLine
@onready var CooldownTimer : Timer = %SlingCooldown
@onready var SfxPlayer : Node = $SfxComponent
@onready var fire_sfx = preload("res://assets/sfx/DESTRUCTION Break Impact Smash Short 03.wav")
@onready var break_sfx = preload("res://assets/sfx/DESTRUCTION Break Impact Smash Short 01.wav")
@onready var PotProjectile = preload("res://scenes/pot_projectile/pot_projectile.tscn")


var dragging : bool = false
var aiming : bool = false
var current_state
var ready_to_fire : bool = true
var cooldown_timer_inactive : bool = true
var pot_projectile


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Slingshot")
	DragComponent.drag_enabled.connect(_on_drag_enabled)
	DragComponent.drag_disabled.connect(_on_drag_disabled)
	FrontLine.points[0] = FrontPoint.position
	BackLine.points[0] = BackPoint.position
	current_state = SlingshotState.idle
	spawn_pot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var drag_pos = get_local_mouse_position()
	
	if drag_pos.distance_to(Center.position) > 150:
		drag_pos = (drag_pos - Center.position).normalized() * 175 + Center.position
	if dragging:
		set_line_points(drag_pos)
	if not dragging:
		set_line_points(Center.position)

	match current_state:

		SlingshotState.idle:
			pot_projectile = get_tree().get_first_node_in_group("PotProjectile")
			if dragging == true:
				current_state = SlingshotState.ready

		SlingshotState.ready:
			pot_projectile.position = drag_pos
			if dragging == false:
				var distance = drag_pos.distance_to(Center.position)
				var velocity = (Center.position - drag_pos)
				fire(pot_projectile, distance, velocity)
				current_state = SlingshotState.fired


		SlingshotState.cooldown:
			if cooldown_timer_inactive and not ready_to_fire:
				start_cooldown_timer()
			if ready_to_fire:
				spawn_pot()
				current_state = SlingshotState.idle


func spawn_pot():
	var new_pot = PotProjectile.instantiate()
	new_pot.position = Center.position
	add_child(new_pot)
	new_pot.connect("pot_impacted", _on_pot_impacted)


func start_cooldown_timer():
	CooldownTimer.start()
	cooldown_timer_inactive = false


func fire(projectile, velocity, distance):
	ready_to_fire = false
	SfxPlayer.play_sfx(fire_sfx)
	projectile.apply_impulse(velocity / 20 * distance)
	projectile.throw_pot()
	

func set_line_points(pos : Vector2):
	FrontLine.points[1] = pos
	BackLine.points[1] = pos


func _on_drag_enabled():
	if current_state == SlingshotState.idle or current_state == SlingshotState.ready:
		dragging = true


func _on_drag_disabled():
	dragging = false


func _on_sling_cooldown_timeout():
	ready_to_fire = true
	cooldown_timer_inactive = true
	emit_signal("cooldown_finished")
	

func _on_pot_impacted():
	SfxPlayer.play_sfx(break_sfx)
	current_state = SlingshotState.cooldown
	

