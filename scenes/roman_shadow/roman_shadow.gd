extends CharacterBody2D


signal death


enum EnemyState{
	walking,
	attacking,
	idle
}


@export var health : int = 100
@export var speed = 3000.0

@onready var AnimatedSprite : AnimatedSprite2D = $AnimationPlayer
@onready var AttackTimer : Timer = $AttackTimer


var current_state

var direction = "left"
var current_opponent : Node2D
var dmg : int = 10
var attack_timer_started = false


func _ready():
	if direction == "left":
		speed *= -1

	current_state = EnemyState.walking

	
func _physics_process(delta):
	$ProgressBar.value = health
	match current_state:

		EnemyState.walking:
			AnimatedSprite.play("walk")
			velocity.x = speed * delta
			move_and_slide()

		EnemyState.attacking:
			if current_opponent: start_attack_timer()

		EnemyState.idle:
			AnimatedSprite.play("idle")



func attack():
	AnimatedSprite.play("attack")
	if not current_opponent: return
	if current_opponent.has_method("take_damage"):
		current_opponent.take_damage(dmg)


func start_attack_timer():
	if attack_timer_started: return
	attack_timer_started = true
	AttackTimer.start()


func take_damage(damage):
	health -= damage
	if health <= 0:
		emit_signal("death")
		queue_free()


func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"): 
		current_opponent = body
		current_state = EnemyState.attacking
	else: 
		current_state = EnemyState.idle


func _on_attack_area_body_exited(body):
	current_state = EnemyState.walking
	current_opponent = null


func _on_attack_timer_timeout():
	attack_timer_started = false
	if current_opponent: attack()
