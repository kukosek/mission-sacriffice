extends ParallaxLayer

var pos_x_min = 800
var pox_x_max = 1000
var pox_y_min = 64
var pox_y_max = 224


onready var EXPLOSION = load("res://Scenes/things/explosions/Explosion.tscn")
var rng = RandomNumberGenerator.new()

var exploding = false
func spawn_explosion():
	var explosion = EXPLOSION.instance()
	add_child(explosion)
	var e_sprite = explosion.get_node("AnimatedSprite")
	rng.randomize()
	e_sprite.position.x = rng.randf_range(pos_x_min, pox_x_max)
	rng.randomize()
	e_sprite.position.y = rng.randf_range(pox_y_min, pox_y_max)
	explosion.explode()

var next_explosion_remaining_counter = 0
func _process(delta):
	if exploding:
		if next_explosion_remaining_counter <= 0:
			spawn_explosion()
			rng.randomize()
			next_explosion_remaining_counter = rng.randf_range(0.5, 2.5)
		else:
			next_explosion_remaining_counter -= delta
