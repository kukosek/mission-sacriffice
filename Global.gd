extends Node


var hp
var landed

var counting_down
var explode_time_left
var exploding
var lab_destroy

var voice_areas_visited_names

var coming_from_right

var dead_enemy_names

var last_waypoint_pos
var last_waypoint_remaining_time

var boss_pushed_button_names



func _ready():
	defaults()

func defaults():
	hp = 3
	landed = false

	counting_down = false
	explode_time_left = 20
	exploding = false
	lab_destroy = false

	voice_areas_visited_names = []

	coming_from_right = false

	dead_enemy_names = []

	last_waypoint_pos = Vector2.ZERO
	last_waypoint_remaining_time = 0.0

	boss_pushed_button_names = []
