extends Node2D


export (int) var enemy_vision = 500
onready var wall_detector_left = $WallDetectorLeft
onready var wall_detector_right = $WallDetectorRight
onready var player_detector_left = $PlayerDetectorLeft
onready var player_detector_right = $PlayerDetectorRight

var detected = false
var detected_position = null
func _ready():
	wall_detector_left.cast_to.x = -enemy_vision
	wall_detector_right.cast_to.x = enemy_vision

const cast_limit_offset = -15
func _process(delta):
	if wall_detector_right.is_colliding():
		player_detector_right.cast_to.x = wall_detector_right.get_collision_point().x- global_position.x + cast_limit_offset
	else:
		player_detector_right.cast_to.x = enemy_vision
	if wall_detector_left.is_colliding():
		
		player_detector_left.cast_to.x = -(global_position.x - wall_detector_left.get_collision_point().x + cast_limit_offset)
	else:
		player_detector_left.cast_to.x = -enemy_vision
	if player_detector_left.is_colliding():
		detected = true
		detected_position = player_detector_left.get_collision_point()
	elif player_detector_right.is_colliding():
		detected = true
		detected_position = player_detector_right.get_collision_point()
	else:
		detected = false
		detected_position = null
