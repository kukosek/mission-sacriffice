extends AnimatedSprite

onready var control = $ControlPanel
onready var earth_layer = get_node("../MoonBackground/ParallaxBackground3/ParallaxLayer")
onready var lab_exploder = get_node("../Exploder")

func start_countdown():
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
			if not control.self_destroy:
				earth_layer.exploding = true
			else:
				lab_exploder.exploding = true
			Global.counting_down = false
func _on_StartSFX_finished():
	$WorkingSFX.play()
