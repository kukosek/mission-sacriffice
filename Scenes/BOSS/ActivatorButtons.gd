extends Node2D

onready var destroyer = get_parent()
onready var not_working_sfx = get_parent().get_node("NotWorkingSFX")

func notifyButtonStatesChanged():
	for button in get_children():
		if not button.pushed:
			not_working_sfx.play()
			return 0
	destroyer.start_countdown()
