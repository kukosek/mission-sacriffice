extends Area2D

const SPEED = 800
var velocity = Vector2()
var direction = 1
func _ready():
	$AnimatedSprite.play("shoot")
	$AudioStreamPlayer2D.play()

func set_fireball_direction(dir):
	if dir == false:
		direction = 1
	else:
		$AnimatedSprite.flip_h = true
		direction = -1
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_fireball_body_entered(body):
	if body.name != "Player" and body.name != "LunarLander":
		if body.has_method("damage"):
			if not body.dead:
				body.damage(1)
				queue_free()
		else:
			queue_free()
