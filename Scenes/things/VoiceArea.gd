extends Area2D

onready var collision = $CollisionShape2D
export (AudioStreamOGGVorbis) var stream = load("res://Scenes/things/cia_voice/go ageah and check it.ogg")
var player
func _ready():
	player = AudioStreamPlayer2D.new()
	player.stream = stream
	add_child(player)
	player.global_position = collision.global_position
	connect("body_entered", self, "player_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func player_entered(body):
	if body.name == "Player":
		if not name in Global.voice_areas_visited_names:
			player.play()
			Global.voice_areas_visited_names.append(name)
