extends Node2D

onready var lose_screen = get_node("Player/Player/HUD/EndScreen")
onready var lab_exploder = $Exploder

func _ready():
	var player = get_node("Player/Player")
	if Global.coming_from_right:
		player.global_position = $SpawnRight.global_position
	else:
		player.global_position = $SpawnLeft.global_position
	
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
