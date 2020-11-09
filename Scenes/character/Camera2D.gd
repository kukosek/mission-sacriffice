extends Camera2D

var last_screen_size = Vector2()
func _process(delta):
	var screen_size = get_viewport_rect().size * zoom
	if screen_size != last_screen_size:
		offset.y = -screen_size.y/5
	last_screen_size = screen_size
export (bool) var enable_scroll_zoom = true
export (float) var zoom_addition_scalar = 0.01
var zoom_addition = Vector2(zoom_addition_scalar, zoom_addition_scalar)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_DOWN:
					if enable_scroll_zoom:# and (zoom+zoom_addition).x < 1.45:
						zoom += zoom_addition
						
				BUTTON_WHEEL_UP:
					if enable_scroll_zoom and (zoom-zoom_addition).x > 0.35:
						zoom -= zoom_addition
