extends Light2D

export (int) var light_cells_outreach = 1.0 #Make it bigger and the light will be at more cells down

var texture_size
var tilemap_top_y

func _ready():
	visible = true
	texture_size = texture.get_size()
	var tilemap = get_parent().get_node("TileMap")
	tilemap_top_y = (8+light_cells_outreach)*tilemap.cell_size.y*tilemap.scale.y


#The light is just a texture, and we must determine how big it should be and where should it be placed.
#If we forced the values, it will be right just at a parteticular screen size
#So when screen size changes, this all is automatically calculated again 
var last_screen_size = Vector2()
var base_position_y
func _process(delta):
	var screen_size = get_viewport_rect().size * get_parent().get_node("Player/Player/Camera2D").zoom
	if screen_size != last_screen_size:
		var light_size = screen_size*1.2
		scale = light_size/texture_size
		base_position_y = (tilemap_top_y-light_size.y) + light_size.y / 2
	var playerpos = get_parent().get_node("Player/Player").position
	position.x = playerpos.x
	if playerpos.y < base_position_y:
		position.y = playerpos.y
	else:
		position.y = base_position_y
	last_screen_size = screen_size
