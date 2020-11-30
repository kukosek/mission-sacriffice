extends Node2D

onready var end_screen = get_node("Player/Player/HUD/EndScreen")
onready var lab_explosion_effects = $LabExplosionSFX
onready var earth_destroyer = get_node("MoonBackground/ParallaxBackground3/ParallaxLayer")

func _process(delta):
	if Global.counting_down:
		if Global.explode_time_left > 0:
			Global.explode_time_left -= delta
		else:
			if not Global.lab_destroy:
				end_screen.lose()
				earth_destroyer.exploding = true
			else:
				end_screen.win()
				lab_explosion_effects.play()
			Global.counting_down = false
func _ready():
	Music.play_music()
			
