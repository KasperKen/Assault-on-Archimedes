extends Node


var current_player : AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_player():
	for i in get_children():
		if not i.playing: return i
		
func play_sfx(sfx):
	var player = get_player()
	player.stream = sfx
	player.play()
