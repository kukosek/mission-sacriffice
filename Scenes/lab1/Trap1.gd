extends Area2D

onready var sound = $AcidSound

func _on_Trap1_body_entered(body):
	if body.has_method("damage"):
		body.damage(100)
		sound.play()
