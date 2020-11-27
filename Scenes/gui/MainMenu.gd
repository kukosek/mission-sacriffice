extends Control

var background_sprite
var background_size

func _ready():
	background_sprite = $fotka
	background_size = background_sprite.get_rect().size

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		
var last_screen_size = Vector2.ZERO
func _process(delta):
	var screen_size = get_viewport_rect().size
	if screen_size != last_screen_size:
		background_sprite.scale = screen_size / background_size
		last_screen_size = screen_size


func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/moon1/moon.tscn")


func _on_Quit_pressed():
	get_tree().quit()
