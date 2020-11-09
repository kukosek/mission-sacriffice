extends Camera2D

var target_zoom
func _ready():
	target_zoom = zoom

export (int) var zoom_speed = 10
	

var last_screen_size = Vector2()

var forced_offset = 0
func reset_offset(screen_size = null):
	forced_offset = null
	if screen_size == null:
		screen_size = get_viewport_rect().size * zoom
	offset.y = -screen_size.y/5

func _process(delta):
	var screen_size = get_viewport_rect().size * zoom
	if screen_size != last_screen_size and forced_offset == null:
		reset_offset(screen_size)
	last_screen_size = screen_size
	
	if target_zoom != null:
		var smooth_zoom = zoom.x
		smooth_zoom = lerp(smooth_zoom, target_zoom.x, zoom_speed * delta)
		if abs(smooth_zoom - target_zoom.x) > 0.05:
			set_zoom(Vector2(smooth_zoom, smooth_zoom))
		else:
			set_zoom(Vector2(target_zoom.x, target_zoom.x))
	
export (bool) var enable_scroll_zoom = true
export (float) var zoom_addition_scalar = 0.2
var zoom_addition = Vector2(zoom_addition_scalar, zoom_addition_scalar)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_DOWN:
					if enable_scroll_zoom:# and (zoom+zoom_addition).x < 1.45:
						target_zoom += zoom_addition
						
				BUTTON_WHEEL_UP:
					if enable_scroll_zoom and (target_zoom-zoom_addition).x > 0.35:
						target_zoom -= zoom_addition
