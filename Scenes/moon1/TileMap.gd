extends TileMap

var tile_break_sfxs = [
	load("res://Scenes/moon1/sfx/kick01.ogg"),
	load("res://Scenes/moon1/sfx/kick02.ogg"),
	load("res://Scenes/moon1/sfx/kick03.ogg")
					]
					
export (bool) var enable_tile_breaking = false
#Tile breaking is handled here
func _input(event):
	if enable_tile_breaking:
		if event is InputEventMouseButton: #If a mouse-related event happened
			var pos = get_global_mouse_position() #Convert screen mouse pos to global world position
			print(pos)
			if event.pressed and event.button_index == BUTTON_RIGHT: #If you clicked your right mouse button
				var tile_pos = world_to_map(pos/scale) #Convert world pos to TileMap coordinates
				var tile_index = get_cellv(tile_pos) #Get index of tile clicked
				if tile_index != -1: #-1 means no tile is there
					$AudioStreamPlayer2D.stream = tile_break_sfxs[randi() % tile_break_sfxs.size()] #Play a random sound
					$AudioStreamPlayer2D.playing = true
					set_cellv(tile_pos, -1) #Remove the tile by setting the index to -1
