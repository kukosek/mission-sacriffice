extends Area2D

export (String) var target_scene = "res://Scenes/lab1/lab.tscn"

func _on_LabEntranceDetection_body_entered(_body):
	get_tree().change_scene(target_scene)
