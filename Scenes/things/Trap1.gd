extends Area2D

onready var sound = $AcidSound

func _on_Trap1_body_entered(body):
	if body.has_method("damage"):
		body.damage(100)
		sound.play()


func _on_Spikes5_body_entered(body):
	pass # Replace with function body.
