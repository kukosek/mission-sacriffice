extends KinematicBody2D

export (int) var gravity = 1200

var velocity = Vector2()
var player_in_lander = true

var player
var hint
var camera

onready var fire_sprite = $FireSprite
var landed = false

func _ready():
	velocity.y = 2000
	player = get_parent().get_node("Player/Player")
	hint = player.get_node("HUD/Hint")
	player.in_lander = true
	player.visible = false
	camera = player.get_node("Camera2D")
func _physics_process(delta):
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if position.y > -350 and velocity.y > 0:
		if velocity.y > 200 and position.y < 5000:
			velocity.y -= gravity * delta * 2.7
		fire_sprite.play("land")
	if velocity.y == 0 and not landed:
		landed = true
		hint.text = "press enter to exit"
	if player_in_lander:
		player.position = position
		player.position.y -= 100
		if Input.is_action_pressed('ui_accept'):
			player.in_lander = false
			player_in_lander = false
			player.visible = true
			camera.reset_offset()
			camera.target_zoom = Vector2(1.0, 1.0)
			hint.text = ""

func _on_FireSprite_animation_finished():
	if fire_sprite.animation == "land":
		fire_sprite.visible = false
