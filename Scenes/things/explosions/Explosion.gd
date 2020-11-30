extends Node2D

onready var sprite = $AnimatedSprite
onready var sfx = $AudioStreamPlayer2D

var numOfAnimations = 3
var rng = RandomNumberGenerator.new()
var exploding = false
func explode():
	rng.randomize()
	var anim_num = rng.randi_range(1, 3)
	sprite.play(str(anim_num))
	exploding = true
	sfx.play()
	
var played_anim = false
var played_sound = false

func _on_AnimatedSprite_animation_finished():
	if exploding:
		sprite.visible = false
		played_sound = true
		if played_sound and played_anim:
			queue_free()


func _on_AudioStreamPlayer2D_finished():
	if exploding:
		played_sound = true
		if played_sound and played_anim:
			queue_free()
