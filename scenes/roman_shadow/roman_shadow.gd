extends CharacterBody2D


signal death


enum EnemyState{
	walking,
	attacking,
	idle,
	trapped
}


@export var health : int = 100
@export var speed = 3000.0


@onready var AnimatedSprite : AnimatedSprite2D = $AnimationPlayer
@onready var AttackTimer : Timer = $AttackTimer
@onready var SfxPlayer: Node = $SfxComponent
@onready var attack_sfx = preload("res://assets/sfx/SWIPE Blade Chop Clang 01.wav")
@onready var TrapTimer = $TrapTimer


var current_state
var direction = "left"
var current_opponent : Node2D
var dmg : int = 10
var attack_timer_started = false
var trapped : bool = false


func _ready():
	if direction == "left":
		speed *= -1

	current_state = EnemyState.walking

	
func _physics_process(delta):
	$ProgressBar.value = health
	if trapped: current_state = EnemyState.trapped
	
	match current_state:

		EnemyState.walking:
			AnimatedSprite.play("walk")
			position += Vector2(-1,0)

		EnemyState.attacking:
			if current_opponent: start_attack_timer()

		EnemyState.idle:
			AnimatedSprite.play("idle")
		
		EnemyState.trapped:
			AnimatedSprite.play("idle")
			if not trapped: current_state = EnemyState.walking



func attack():
	AnimatedSprite.play("attack")
	if not current_opponent: return
	SfxPlayer.play_sfx(attack_sfx)
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


func trap():
	trapped = true
	TrapTimer.start()

func release():
	trapped = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"): 
		current_opponent = body
		current_state = EnemyState.attacking
	else: 
		current_state = EnemyState.idle


func _on_attack_area_body_exited(body):
	current_opponent = null
	if trapped == true:
		current_state = EnemyState.trapped
	else: 
		current_state = EnemyState.walking


func _on_attack_timer_timeout():
	attack_timer_started = false
	if current_opponent: attack()


func _on_trap_timer_timeout():
	release()
