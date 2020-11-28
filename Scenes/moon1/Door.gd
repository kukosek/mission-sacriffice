extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $AnimatedSprite
onready var player = get_parent().get_node("Player/Player")
onready var open_sfx = $OpenSFX
onready var close_sfx = $CloseSFX

onready var hint = get_parent().get_node("Player/Player/HUD/Hint")
var opened = false
func toggleOpen():
	if sprite.animation == "open":
		sprite.play("closed")
		close_sfx.play()
		opened = false
	else:
		sprite.play("open")
		open_sfx.play()
		opened = true
	set_collision_layer_bit(0, !get_collision_layer_bit(0))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func player_is_in_range():
	var delta_pos = Vector2(abs(player.position.x - position.x), abs(player.position.y - position.y))
	return delta_pos.x < 200 and delta_pos.y < 100

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_use"):
			if player_is_in_range():
				hint.text = ""
				toggleOpen()

func _process(_delta):
	if player_is_in_range() and not opened:
		hint.text = "press e to open"
