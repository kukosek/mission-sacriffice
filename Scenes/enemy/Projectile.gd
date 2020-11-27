extends KinematicBody2D

func fire(side):
	$Sprite.flip_h = side
	if side:
		velocity = speed
	else:
		velocity = -speed

export (Vector2) var speed = Vector2(650, 0)
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))


func _on_Area2D_body_entered(body):
	if body != self and body.name != "Enemy":
		if body.name == "Player":
			body.damage(1)
		queue_free()
