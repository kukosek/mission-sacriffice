extends Node2D


var side_right = false

var _detected_bodies = []

func damage_enemies():
	for body in _detected_bodies:
		if body.has_method("damage"):
			body.damage(2)

func _ready():
	pass # Replace with function body.


func _on_Right_body_entered(body):
	if side_right:
		_detected_bodies.append(body)

func _on_Left_body_entered(body):
	if not side_right:
		_detected_bodies.append(body)


func _on_Left_body_exited(body):
	if body in _detected_bodies:
		_detected_bodies.erase(body)


func _on_Right_body_exited(body):
	if body in _detected_bodies:
		_detected_bodies.erase(body)
