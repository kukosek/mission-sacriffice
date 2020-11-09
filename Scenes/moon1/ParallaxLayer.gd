extends ParallaxLayer


var last_screen_size = Vector2()
func _process(delta):
	var screen_size = get_viewport_rect().size * get_parent().get_parent().get_node("Player/KinematicBody2D/Camera2D").zoom
	if screen_size != last_screen_size:
		var sprite_scale = 4
		var sprite = get_children()[0]
		sprite.scale = Vector2(sprite_scale, sprite_scale)
		var sprite_size = sprite.get_rect().size
		var rect = Rect2(0, 0, sprite_size.x * ceil(screen_size.x / sprite_size.x/sprite_scale),
		 sprite_size.y)
		sprite.region_rect = rect
		sprite.region_enabled = true
		motion_mirroring = Vector2(rect.size.x*sprite_scale, 0)
		if get_parent().name == "ParallaxBackground2":
			rect.size.y = sprite_size.y * ceil(screen_size.y / sprite_size.y/sprite_scale)
			sprite.region_rect = rect
			motion_mirroring.y = rect.size.y*sprite_scale
	last_screen_size = screen_size
