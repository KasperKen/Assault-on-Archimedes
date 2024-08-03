extends RigidBody2D


@onready var OilAnimation : AnimatedSprite2D = $OilAnimation
@onready var DespawnTimer : Timer = $DespawnTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	OilAnimation.play("spill")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func burn():
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("greased"): body.greased()


func _on_despawn_timer_timeout():
	queue_free()
