extends AudioStreamPlayer2D

func _process(_delta):
	if Global.counting_down and not playing:
		play()
	elif not Global.counting_down and playing:
		playing = false
