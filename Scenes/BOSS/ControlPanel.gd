extends AnimatedSprite

onready var destroyer = get_parent()
onready var player = get_node("../../Player/Player")
onready var hint = get_node("../../Player/Player/HUD/Hint")
onready var change_sfx = $ChangeSFX
onready var glass_door = get_node("../GlassDoor")

export (int) var range_x = 200
export (int) var range_y = 100
export (bool) var show_hint = true

var self_destroy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	glass_door.playing = true

func player_is_in_range():
	var delta_pos = Vector2(abs(player.global_position.x - global_position.x), abs(player.global_position.y - global_position.y))
	return delta_pos.x < range_x and delta_pos.y < range_y

func _input(event):
	if not Global.counting_down:
		if event is InputEventKey:
			if event.is_action_pressed("ui_use"):
				if player_is_in_range():
					if show_hint:
						hint.text = ""
						show_hint = false
					change_sfx.play()
					if not self_destroy:
						glass_door.play("backwards")
						play("aim_moon")
						destroyer.play("self")
						destroyer.playing = false
						self_destroy = true
					else:
						glass_door.play("default")
						play("aim_earth")
						destroyer.play("kill")
						destroyer.playing = false
						self_destroy = false
var showing_hint = false
func _process(_delta):
	if player_is_in_range() and show_hint and not Global.counting_down:
		if show_hint:
			showing_hint = true
			hint.text = "press e to use"
	elif showing_hint:
		showing_hint = false
		hint.text = ""
