extends StaticBody2D


@onready var EnemySpawnPoint : Marker2D = $EnemySpawnPoint
@onready var EnemySpawnTimer : Timer = $EnemySpawnTimer
@onready var Enemy : PackedScene = preload("res://scenes/roman_shadow/roman_shadow.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_enemy():
	var new_enemy = Enemy.instantiate()
	new_enemy.position = EnemySpawnPoint.position
	add_child(new_enemy)

func _on_enemy_spawn_timer_timeout():
	spawn_enemy()
