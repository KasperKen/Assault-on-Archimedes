extends Control


@onready var hotbar_button_array : Array = get_tree().get_nodes_in_group("HotBarButtons")
@onready var CooldownTimer : Timer = $CooldownTimer
@onready var HotbarButton : Button = $"."
@onready var CooldownBar : ProgressBar = $CooldownBar


@export var Ammo : PackedScene
@export var CooldownTime : float


var effect_enabled : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	CooldownBar.max_value = CooldownTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	CooldownBar.value = CooldownTimer.time_left


func start_cooldown():
	self.disabled = true
	self.button_pressed = false
	self.text = "X"
	effect_enabled = false
	CooldownTimer.start(CooldownTime)

 
func _on_toggled(toggled_on):
	if toggled_on:
		effect_enabled = true
	else:
		effect_enabled = false


func _on_cooldown_timer_timeout():
	self.disabled = false
	self.text = ""
