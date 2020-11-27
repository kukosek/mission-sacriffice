extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $AnimatedSprite
onready var player = get_parent().get_node("Player/Player")
onready var open_sfx = $OpenSFX
onready var close_sfx = $CloseSFX

func toggleOpen():
	if sprite.animation == "open":
		sprite.play("closed")
		close_sfx.play()
	else:
		sprite.play("open")
		open_sfx.play()
	set_collision_layer_bit(0, !get_collision_layer_bit(0))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_use"):
			var delta_pos = Vector2(abs(player.position.x - position.x), abs(player.position.y - position.y))
			if delta_pos.x < 200 and delta_pos.y < 100:
				toggleOpen()
