extends KinematicBody2D

export (int) var gravity = 1200

var velocity = Vector2()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
