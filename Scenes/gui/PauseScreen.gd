extends CenterContainer

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = !visible

var last_screen_size = Vector2.ZERO

onready var darkening_sprite = $DarkeningSprite
func _process(delta):
	if visible:
		var screen_size = get_viewport_rect().size
		if screen_size != last_screen_size:
			rect_size = screen_size / rect_scale
			last_screen_size = screen_size
		darkening_sprite.scale = screen_size

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/gui/MainMenu.tscn")


func _on_Resume_pressed():
	toggle_pause()
