extends Node


var hp = 3
var landed = false

var counting_down = false
var explode_time_left = 20
var exploding = false
var lab_destroy = false

var voice_areas_visited_names = []

var coming_from_right = false

var dead_enemy_names = []

var last_waypoint_pos = Vector2.ZERO
var last_waypoint_remaining_time = 0.0

var boss_pushed_button_names = []
