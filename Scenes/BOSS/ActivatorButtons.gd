extends Node2D

onready var destroyer = get_parent()

func notifyButtonStatesChanged():
	for button in get_children():
		if not button.pushed:
			return 0
	destroyer.start_countdown()
