extends Camera2D


enum CameraState{
	idle,
	default,
	follow
}


@onready var Camera : Camera2D = $"."
@onready var DefaultCameraLocation : Marker2D = $"../DefaultCameraLocation"
@onready var Slingshot : Node2D = $"../Slingshot"
@onready var CameraBoundary : Area2D = %CameraBoundary

var camera_state = CameraState.default
var threshold: int = 45
var step: int = 8
var local_mouse_pos : Vector2
var pot_connected : bool = false
var current_pot : RigidBody2D
var viewport_size : Vector2
var left_scroll : bool = true
var right_scroll : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Slingshot.connect("cooldown_finished", _on_cooldown_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_pot = get_tree().get_first_node_in_group("PotProjectile")
	if current_pot: connect_pot()
	local_mouse_pos = get_viewport().get_mouse_position()
	viewport_size = get_viewport().size
	print_debug(local_mouse_pos)


	match camera_state:

		CameraState.default:
			if local_mouse_pos.x < threshold and left_scroll:
				position.x -= step
			elif local_mouse_pos.x >= (640) - threshold and right_scroll:
				position.x += step

		CameraState.follow:
			location(current_pot.global_position)


func location(location):
	global_position = location



func connect_pot():
	if pot_connected: return
	current_pot.connect("pot_thrown", _on_pot_thrown)
	current_pot.connect("pot_impacted", _on_pot_impacted)
	pot_connected = true


func disconnect_pot():
	current_pot.disconnect("pot_thrown", _on_pot_thrown)
	current_pot.disconnect("pot_impacted", _on_pot_impacted)
	pot_connected = false


func _on_pot_impacted():
	disconnect_pot()
	camera_state = CameraState.idle


func _on_pot_thrown():
	camera_state = CameraState.follow
	

func _on_cooldown_finished():
	camera_state = CameraState.default
	location(DefaultCameraLocation.global_position)


func _on_camera_boundary_body_entered(body):
	if body.is_in_group("no_left"): left_scroll = false
	if body.is_in_group("no_right"): right_scroll = false


func _on_camera_boundary_body_exited(body):
	if body.is_in_group("no_left"): left_scroll = true
	if body.is_in_group("no_right"): right_scroll = true
