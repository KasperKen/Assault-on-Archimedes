extends Node2D


@onready var GreekBase = $Level/PlayArea/GreekBase

# Called when the node enters the scene tree for the first time.
func _ready():
	GreekBase.connect("base_destroyed", _on_base_destroyed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_base_destroyed():
	Global.game_over = true
