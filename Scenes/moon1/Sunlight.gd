extends Light2D

export (int) var light_cells_outreach = 1.0
var texture_size
var tilemap_top_y
func _ready():
	visible = true
	texture_size = texture.get_size()
	var tilemap = get_parent().get_node("TileMap")
	tilemap_top_y = (8+light_cells_outreach)*tilemap.cell_size.y*tilemap.scale.y
var last_screen_size = Vector2()
var base_position_y
func _process(delta):
	var screen_size = get_viewport_rect().size * get_parent().get_node("Player/KinematicBody2D/Camera2D").zoom
	if screen_size != last_screen_size:
		var light_size = screen_size*1.2
		scale = light_size/texture_size
		base_position_y = (tilemap_top_y-light_size.y) + light_size.y / 2
	var playerpos = get_parent().get_node("Player/KinematicBody2D").position
	position.x = playerpos.x
	if playerpos.y < base_position_y:
		position.y = playerpos.y
	else:
		position.y = base_position_y
	last_screen_size = screen_size
