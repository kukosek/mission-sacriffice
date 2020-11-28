extends Label



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export (bool) var dynamic_y = true
export (bool) var dynamic_x = true
export (bool) var y_subtraction = true
export (int) var x_subtraction = 10
export (int) var scale = 2

var last_screen_size = Vector2.ZERO
func _process(_delta):
	if visible:
		var screen_size = get_viewport_rect().size
		if screen_size != last_screen_size:
			if dynamic_x:
				rect_size.x = screen_size.x / scale
				rect_size.x -= x_subtraction
			if dynamic_y:
				rect_size.y = screen_size.y / scale
			if y_subtraction:
				rect_size.y -= screen_size.y/15
			last_screen_size = screen_size
