extends CenterContainer

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = !visible


onready var darkening_sprite = $DarkeningSprite
onready var label = $VBoxContainer/Label
onready var cia_happy = $VBoxContainer/CiaHappy
onready var east_happy = $VBoxContainer/EastHappy
onready var playtime_label = get_node("../Playtime")

func show_playtime():
	playtime_label.visible = true
	playtime_label.text = "Playtime: " + str((OS.get_unix_time() - Global.start_time)) + "s"

func win():
	label.text = "You win!"
	visible = true
	cia_happy.visible = true
	show_playtime()
func lose():
	label.text = "You lose!"
	visible = true
	east_happy.visible = true
	show_playtime()
var last_screen_size = Vector2.ZERO
func _process(_delta):
	if visible:
		var screen_size = get_viewport_rect().size
		if screen_size != last_screen_size:
			rect_size = screen_size / rect_scale
			last_screen_size = screen_size
			playtime_label.rect_size.y = (screen_size.y - 60) / playtime_label.rect_scale.y
		darkening_sprite.scale = screen_size

func _on_Quit_pressed():
	if visible:
		get_tree().change_scene("res://Scenes/gui/MainMenu.tscn")
