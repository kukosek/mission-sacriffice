extends Camera2D



var target_zoom = Vector2(1.0, 1.0) #At runtime, You can set this variable to a Vector2 value and the camera will smoothly zoom to it

export (int) var zoom_speed = 10 #How fast the smooth zooming will be

export (float) var max_zoom = 1.7

var last_screen_size = Vector2()

var forced_offset = 0 #You can set this to a value and the camera will keep the offset regardless of screen size.
#If you wish the offset to be automatic, call the function reset_offset()
#	and the forced_offset variable will be set to null.

func _ready():
	zoom = target_zoom

#Called everytime when screen size changes if forced offset is not set
func reset_offset(screen_size = null):
	forced_offset = null
	if screen_size == null:
		screen_size = get_viewport_rect().size * zoom
	offset.y = -screen_size.y/5

var last_screen_no_z 
var last_zoom = Vector2.ZERO
func _process(delta):
	#Detecting screen size changes to reset the offset if needed
	var screen_size = get_viewport_rect().size * zoom
	if screen_size != last_screen_size and forced_offset == null:
		reset_offset(screen_size)

	var screen_size_no_z = get_viewport_rect().size
	if last_screen_size.x != 0 and last_zoom.x != 0:
		var previous_screen = round(last_screen_no_z.x*last_zoom.x)
		var current_screen = round(screen_size_no_z.x * target_zoom.x)
		if last_screen_no_z != screen_size_no_z:
			target_zoom /=  stepify(float(current_screen) / float(previous_screen), 0.1)
	if last_zoom != target_zoom:
		last_zoom = target_zoom
	last_screen_size = screen_size
	last_screen_no_z = screen_size_no_z
	#Handling smoothly zooming every frame to the target_zoom
	if target_zoom != null:
		var smooth_zoom = zoom.x
		smooth_zoom = lerp(smooth_zoom, target_zoom.x, zoom_speed * delta)
		if abs(smooth_zoom - target_zoom.x) > 0.05:
			set_zoom(Vector2(smooth_zoom, smooth_zoom))
		else:
			set_zoom(Vector2(target_zoom.x, target_zoom.x))
	
#Handling zooming with mouse scroll button
export (bool) var enable_scroll_zoom = true #Set it to false if you wanna disable it
export (float) var zoom_addition_scalar = 0.2 #Change it to change the how much zooming is applied

var zoom_addition = Vector2(zoom_addition_scalar, zoom_addition_scalar)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_DOWN:
					#Uncomment the comment bellow me to put a limit
					if enable_scroll_zoom and (last_screen_size.x/500)*(zoom+zoom_addition).x < max_zoom: 
						target_zoom += zoom_addition
						
				BUTTON_WHEEL_UP:
					if enable_scroll_zoom and (target_zoom-zoom_addition).x > 0.35:
						target_zoom -= zoom_addition
