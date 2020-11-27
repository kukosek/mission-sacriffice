extends KinematicBody2D

export (int) var gravity = 1200

var velocity = Vector2()
var player_in_lander = true

var player
var camera

func _ready():
	player = get_parent().get_node("Player/Player")
	player.in_lander = true
	camera = player.get_node("Camera2D")
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if player_in_lander:
		player.position = position
		player.position.y -= 100
		if Input.is_action_pressed('ui_accept'):
			player.in_lander = false
			player_in_lander = false
			camera.reset_offset()
			camera.target_zoom = Vector2(1.0, 1.0)
