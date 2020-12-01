extends Area2D

onready var sound = $AcidSound

func _ready():
	if sound == null:
		sound = AudioStreamPlayer2D.new()
		add_child(sound)
		sound.stream = load("res://Scenes/lab1/sfx/die_in_acid.ogg")

func _on_Trap1_body_entered(body):
	if body.has_method("damage"):
		body.damage(100)
		sound.play()
