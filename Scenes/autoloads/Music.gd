extends AudioStreamPlayer

var wmusic = load("res://Scenes/moon1/sfx/wildmusic.ogg")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func play_music():
	stream = wmusic
	play()
