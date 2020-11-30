extends Node2D

export var state = "0"
onready var sprite = $AnimatedSprite
func _ready():
	if state == "0":
		sprite.play("on")
	else:
		sprite.play("off")
func _process(delta):
	
	if $Area2D.overlaps_body($"../Player"):
		$SFX.play()
		if state == "0":
			state = "1"
		else:
			state = "0"
	if state == "0":
		sprite.play("on")
	else:
		sprite.play("off")
