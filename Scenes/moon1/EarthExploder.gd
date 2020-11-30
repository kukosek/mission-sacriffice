extends ParallaxLayer

var pos_x_min = 800
var pox_x_max = 1000
var pox_y_min = 64
var pox_y_max = 224


onready var EXPLOSION = load("res://Scenes/things/explosions/Explosion.tscn")
var rng = RandomNumberGenerator.new()
func start_exploding():
	for i in range(5):
		var explosion = EXPLOSION.instance()
		spawn_explosion()
func spawn_explosion():
	var explosion = EXPLOSION.instance()
	add_child(explosion)
	rng.randomize()
	position.x = rng.randf_range(pos_x_min, pox_x_max)
	rng.randomize()
	position.y = rng.randf_range(pox_y_min, pox_y_max)
	explosion.explode()
func _ready():
	start_exploding() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
