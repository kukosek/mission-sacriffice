extends Area2D

func _on_Waypoint_body_entered(body):
	if body.name == "Player":
		Global.last_waypoint_pos = global_position
		Global.last_waypoint_remaining_time = Global.explode_time_left
