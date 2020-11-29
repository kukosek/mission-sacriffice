extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var range_x = 200
export (int) var range_y = 100
export (bool) var show_hint = true
export (String) var target_scene
export (NodePath) var player_path = "../Player"


onready var sprite = $AnimatedSprite
onready var player = get_node(player_path).get_node("Player")
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
	$LabEntranceDetection.target_scene = target_scene

func player_is_in_range():
	var delta_pos = Vector2(abs(player.global_position.x - global_position.x), abs(player.global_position.y - global_position.y))
	return delta_pos.x < range_x and delta_pos.y < range_y

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_use"):
			if player_is_in_range():
				if show_hint:
					hint.text = ""
				toggleOpen()

func _process(_delta):
	if player_is_in_range() and not opened:
		if show_hint:
			hint.text = "press e to open"
