extends CenterContainer


var last_screen_size = Vector2.ZERO

onready var darkening_sprite = $DarkeningSprite
func _process(delta):
	if visible:
		var screen_size = get_viewport_rect().size
		if screen_size != last_screen_size:
			rect_size = screen_size / rect_scale
			last_screen_size = screen_size
		darkening_sprite.scale = screen_size


func _on_Quit_pressed():
	get_tree().change_scene("res://Scenes/gui/MainMenu.tscn")


func _on_Restart_pressed():
	get_tree().change_scene("res://Scenes/moon1/moon.tscn")
