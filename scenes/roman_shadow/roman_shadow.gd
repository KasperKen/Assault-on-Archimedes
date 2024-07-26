extends CharacterBody2D


var speed = 1000.0
var direction = "left"

func _ready():
	if direction == "left":
		speed *= -1

func _physics_process(delta):
	velocity.x = speed * delta

	move_and_slide()
