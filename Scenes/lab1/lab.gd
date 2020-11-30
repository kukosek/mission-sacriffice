extends Node2D

onready var lose_screen = get_node("Player/Player/HUD/EndScreen")
onready var lab_exploder = $Exploder

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
