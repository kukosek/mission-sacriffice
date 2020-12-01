extends Node2D

onready var lose_screen = get_node("Player/Player/HUD/EndScreen")
onready var lab_exploder = $Exploder
var cia_destroy_earth_sfx
var cia_destroy_lab_sfx

func _ready():
	var player = get_node("Player/Player")
	if Global.last_waypoint_pos == Vector2.ZERO:
		if Global.coming_from_right:
			player.global_position = $SpawnRight.global_position
		else:
			player.global_position = $SpawnLeft.global_position
	else:
		Global.explode_time_left = Global.last_waypoint_remaining_time
		player.global_position = Global.last_waypoint_pos
	cia_destroy_earth_sfx = AudioStreamPlayer2D.new()
	cia_destroy_earth_sfx.stream = load("res://Scenes/things/cia_voice/earth_explode_cia.ogg")
	cia_destroy_earth_sfx.attenuation = 0.09
	cia_destroy_earth_sfx.max_distance = 12000
	add_child(cia_destroy_earth_sfx)
	cia_destroy_lab_sfx = AudioStreamPlayer2D.new()
	cia_destroy_lab_sfx.stream = load("res://Scenes/things/cia_voice/lab_destroy_cia.ogg")
	cia_destroy_lab_sfx.attenuation = 0.09
	cia_destroy_lab_sfx.max_distance = 12000
	add_child(cia_destroy_lab_sfx)
var cia_voice_played = false
func _process(delta):
	if Global.counting_down:
		if Global.explode_time_left > 0:
			Global.explode_time_left -= delta
		else:
			if not Global.lab_destroy:
				lose_screen.lose()
			else:
				lab_exploder.exploding = true
			Global.counting_down = false
		if Global.explode_time_left < 10.0:
			if not cia_voice_played:
				cia_voice_played = true
				if Global.lab_destroy:
					cia_destroy_lab_sfx.play()
				else:
					cia_destroy_earth_sfx.play()
