extends AnimatedSprite

var counting_down = false

onready var control = $ControlPanel

func start_countdown():
	playing = true
	time_left = 60.0
	counting_down = true
	if control.self_destroy:
		$StartSFX.play()
		
func _ready():
	pass # Replace with function body.

var time_left
func _process(delta):
	if counting_down:
		if time_left > 0:
			time_left -= delta
		else:
			print("destroy")
			counting_down = false
func _on_StartSFX_finished():
	$WorkingSFX.play()
