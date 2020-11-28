extends Label



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



var last_screen_size = Vector2.ZERO
func _process(_delta):
	if visible:
		var screen_size = get_viewport_rect().size
		if screen_size != last_screen_size:
			rect_size = screen_size / rect_scale
			rect_size.y -= screen_size.y/15
			last_screen_size = screen_size
