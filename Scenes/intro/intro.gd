extends Node2D

func end_intro():
	fading = true

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("ui_select"):
		end_intro()

onready var overlay = $overlay
var fading = false	
func _process(delta):
	if fading:
		if overlay.modulate.a < 1.0:
			overlay.modulate.a+=.01
		else:
			get_tree().change_scene("res://Scenes/moon1/moon.tscn")
