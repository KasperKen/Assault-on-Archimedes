extends StaticBody2D

signal base_destroyed


@export var health : int = 100


@onready var HealthBar : ProgressBar = $HealthBar



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	HealthBar.value = health


func take_damage(damage):
	health -= damage
	if health <= 0:
		$CollisionShape2D.queue_free()
		emit_signal("base_destroyed")
