extends Area2D

func _on_LabEntranceDetection_body_entered(_body):
	get_tree().change_scene("res://Scenes/lab1/lab.tscn")