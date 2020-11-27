extends Node2D


export (int) var enemy_vision = 500
onready var wall_detector_left = $WallDetectorLeft
onready var wall_detector_right = $WallDetectorRight
onready var player_detector_left = $PlayerDetectorLeft
onready var player_detector_right = $PlayerDetectorRight
onready var player_detector_left2 = $PlayerDetectorLeft2
onready var player_detector_right2 = $PlayerDetectorRight2

var detected = false
var detected_position = null
var right = null
func _ready():
	wall_detector_left.cast_to.x = -enemy_vision
	wall_detector_right.cast_to.x = enemy_vision

const cast_limit_offset = -15
func _process(_delta):
	if wall_detector_right.is_colliding():
		var castpoint = wall_detector_right.get_collision_point().x- global_position.x + cast_limit_offset
		player_detector_right.cast_to.x = castpoint
		player_detector_right2.cast_to.x = castpoint
	else:
		player_detector_right.cast_to.x = enemy_vision
		player_detector_right2.cast_to.x = enemy_vision
	if wall_detector_left.is_colliding():
		var castpoint = -(global_position.x - wall_detector_left.get_collision_point().x + cast_limit_offset)
		player_detector_left.cast_to.x = castpoint
		player_detector_left2.cast_to.x = castpoint
	else:
		player_detector_left.cast_to.x = -enemy_vision
		player_detector_left2.cast_to.x = -enemy_vision
	if player_detector_left.is_colliding():
		right = false
		detected = true
		detected_position = player_detector_left.get_collision_point()
	elif player_detector_left2.is_colliding():
		right = false
		detected = true
		detected_position = player_detector_left2.get_collision_point()
	elif player_detector_right.is_colliding():
		right = true
		detected = true
		detected_position = player_detector_right.get_collision_point()
	elif player_detector_right2.is_colliding():
		right = true
		detected = true
		detected_position = player_detector_right2.get_collision_point()
	else:
		detected = false
		detected_position = null
