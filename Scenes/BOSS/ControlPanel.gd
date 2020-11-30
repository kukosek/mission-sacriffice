extends AnimatedSprite

onready var player = get_parent().get_node("Player/Player")
onready var hint = get_parent().get_node("Player/Player/HUD/Hint")

export (int) var range_x = 200
export (int) var range_y = 100
export (bool) var show_hint = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func player_is_in_range():
	var delta_pos = Vector2(abs(player.global_position.x - global_position.x), abs(player.global_position.y - global_position.y))
	print(delta_pos)
	return delta_pos.x < range_x and delta_pos.y < range_y

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_use"):
			if player_is_in_range():
				if show_hint:
					hint.text = ""
					show_hint = false
				if animation == "aim_earth":
					play("aim_moon")
				else:
					play("aim_earth")

func _process(_delta):
	if player_is_in_range() and show_hint:
		if show_hint:
			hint.text = "press e to use"
