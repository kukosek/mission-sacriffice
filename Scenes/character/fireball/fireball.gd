extends Area2D

const SPEED = 800
var velocity = Vector2()
var direction = 1
var leti = true

func _ready():
	pass # Replace with function body.
	

	
	
func start():
	position = Vector2()
func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
func get_input():
	if Input.is_action_just_pressed("ui_focus_next"):
		$AudioStreamPlayer2D.play()
		
	else:
		pass

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	if leti:
		$AnimatedSprite.play("shoot")
	#else:
		#$AnimatedSprite.play("dopad")
	


	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_fireball_body_entered(_body):
	queue_free()
