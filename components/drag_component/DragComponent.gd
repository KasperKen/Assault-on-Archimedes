extends Area2D


signal drag_enabled
signal drag_disabled


var hover : bool = false
var drag : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hover and Input.is_action_just_pressed("select"):
		enable_drag()
	if drag and Input.is_action_just_released("select"):
		disable_drag()



func enable_drag():
	drag = true
	drag_enabled.emit()


func disable_drag():
	drag = false
	drag_disabled.emit()


func _on_mouse_entered():
	hover = true


func _on_mouse_exited():
	hover = false
