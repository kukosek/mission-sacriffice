extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var range_x = 200
export (int) var range_y = 100
export (bool) var show_hint = true
export (NodePath) var player_path = "../Player"
export (bool) var allow_unpush = false

onready var player = get_node(player_path).get_node("Player")

onready var hint = get_node(player_path).get_node("Player/HUD/Hint")
export (bool) var pushed = false

onready var sfx = AudioStreamPlayer2D.new()

func _ready():
	sfx.stream = load("res://Scenes/moon1/sfx/door_close.ogg")
	add_child(sfx)
	if pushed:
		get_parent().notifyButtonStatesChanged()
func player_is_in_range():
	var delta_pos = Vector2(abs(player.global_position.x - global_position.x), abs(player.global_position.y - global_position.y))
	return delta_pos.x < range_x and delta_pos.y < range_y

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_use"):
			if player_is_in_range():
				if not pushed or allow_unpush:
					sfx.play()
					hint.text = ""
					pushed = !pushed
					if pushed:
						play("pushed")
					else:
						play("default")
					if get_parent().has_method("notifyButtonStatesChanged"):
						get_parent().notifyButtonStatesChanged()
var showing_hint = false
func _process(_delta):
	if player_is_in_range():
		if show_hint:
			showing_hint = true
			hint.text = "press e to use"
			show_hint = false
	elif showing_hint:
		showing_hint = false
		hint.text = ""
