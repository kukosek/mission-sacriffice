extends KinematicBody2D

export (int) var gravity = 1200

var velocity = Vector2()
var player_in_lander = true

onready var player = get_parent().get_node("Player/Player")
var hint
var attitude
var camera

onready var fire_sprite = $FireSprite
var landed = false
onready var rocket_noise = $RocketNoise
onready var radio_audio = $RadioAudio
func _ready():
	if not Global.landed:
		fire_sprite.visible = true
		position.y = -25000
		velocity.y = 2000
		hint = player.get_node("HUD/Hint")
		attitude = player.get_node("HUD/LanderAttitude")
		attitude.visible = true
		player.in_lander = true
		player.visible = false
		camera = player.get_node("Camera2D")
		rocket_noise.play()
		radio_audio.play()
	else:
		player.position.y = 900
func _physics_process(delta):
	if not Global.landed:
		camera.target_zoom = Vector2(2.0, 2.0)
		velocity = move_and_slide(velocity, Vector2(0, -1))
		if position.y > -350 and velocity.y > 0:
			if velocity.y > 200 and position.y < 5000:
				velocity.y -= gravity * delta * 2.7
			rocket_noise.volume_db -= 0.05
			fire_sprite.play("land")
		if velocity.y == 0 and not landed:
			landed = true
			rocket_noise.playing = false
			hint.text = "press enter to exit"
		if player_in_lander:
			if not landed:
				attitude.text = "attitude: " + str(abs((int(position.y)-324)/100)) + "m"
			player.position = position
			player.position.y -= 100
			if Input.is_action_pressed('ui_accept'):
				Global.landed = true
				attitude.visible = false
				player.in_lander = false
				player_in_lander = false
				player.visible = true
				camera.reset_offset()
				camera.target_zoom = Vector2(1.0, 1.0)
				hint.text = ""

func _on_FireSprite_animation_finished():
	if fire_sprite.animation == "land":
		fire_sprite.visible = false
