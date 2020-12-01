extends AnimatedSprite

onready var control = $ControlPanel
onready var earth_layer = get_node("../MoonBackground/ParallaxBackground3/ParallaxLayer")
onready var lab_exploder = get_node("../Exploder")
onready var beam = get_node("beam")
onready var siren = get_node("../lights/siren")
onready var beam_light = $Light2D
onready var siren_sfx = $SirenSFX
onready var run_away_sfx = $RunAwaySFX

func start_countdown():
	run_away_sfx.play()
	siren.visible = true
	siren_sfx.play()
	beam_light.visible = true
	Global.landed = true
	playing = true
	Global.counting_down = true
	Global.lab_destroy = control.self_destroy
	if control.self_destroy:
		$StartSFX.play()
	
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Global.counting_down:
		if Global.explode_time_left > 0:
			Global.explode_time_left -= delta
		else:
			Global.exploding = true
			if not control.self_destroy:
				beam.visible = true
				earth_layer.exploding = true
			else:
				lab_exploder.exploding = true
			Global.counting_down = false
func _on_StartSFX_finished():
	$WorkingSFX.play()
