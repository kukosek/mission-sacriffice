extends TileMap

var tile_break_sfxs = [
	load("res://Scenes/moon1/sfx/kick01.ogg"),
	load("res://Scenes/moon1/sfx/kick02.ogg"),
	load("res://Scenes/moon1/sfx/kick03.ogg")
					]
func _input(event):
	if event is InputEventMouseButton:
		var pos = get_global_mouse_position()
		if event.pressed and event.button_index == BUTTON_RIGHT:
			var tile_pos = world_to_map(pos/scale)
			var tile_index = get_cellv(tile_pos)
			if tile_index != -1:
				$AudioStreamPlayer2D.stream = tile_break_sfxs[randi() % tile_break_sfxs.size()]
				$AudioStreamPlayer2D.playing = true
				set_cellv(tile_pos, -1)
