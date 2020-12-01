extends Node2D

export (int) var pos_x_min = 800
export (int) var pox_x_max = 1000
export (int) var pox_y_min = 64
export (int) var pox_y_max = 224
export (float) var raninterval_min_s = 0.5
export (float) var raninterval_max_s = 2.5
export (float) var explosion_scale = 1
export (NodePath) var player_path = null
var player
var end_screen
func _ready():
	if player_path != null:
		player = get_node(player_path).get_node("Player")
	else:
		player = get_node("../../../Player/Player")
	end_screen = player.get_node("HUD/EndScreen")
onready var EXPLOSION = load("res://Scenes/things/explosions/Explosion.tscn")
var rng = RandomNumberGenerator.new()

var exploding = false
func spawn_explosion():
	var explosion = EXPLOSION.instance()
	add_child(explosion)
	var e_sprite = explosion.get_node("AnimatedSprite")
	e_sprite.scale *= explosion_scale
	rng.randomize()
	e_sprite.position.x = rng.randf_range(pos_x_min, pox_x_max)
	rng.randomize()
	e_sprite.position.y = rng.randf_range(pox_y_min, pox_y_max)
	explosion.explode()
	if pos_x_min != 800:
		player.damage(1)
var next_explosion_remaining_counter = 0
var show_lose_remaining_counter = 2.0
var showed_lose = false
func _process(delta):
	if exploding:
		if next_explosion_remaining_counter <= 0:
			spawn_explosion()
			rng.randomize()
			next_explosion_remaining_counter = rng.randf_range(raninterval_min_s, raninterval_max_s)
		else:
			next_explosion_remaining_counter -= delta
		if not showed_lose and not Global.lab_destroy:
			if show_lose_remaining_counter <= 0:
				end_screen.lose()
				showed_lose = true
			else:
				show_lose_remaining_counter -= delta
