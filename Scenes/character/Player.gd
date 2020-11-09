extends KinematicBody2D

export (int) var run_speed = 300
export (int) var jump_speed = -400
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false

var IN_LANDER = 0
var FREE = 1
var state = IN_LANDER



func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select' )

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if right:
		$AnimatedSprite.flip_h = false
		velocity.x += run_speed
	if left:
		$AnimatedSprite.flip_h = true
		velocity.x -= run_speed

var can_jump = false
const wall_slide_acce = 10
const max_wall_speed = 120
const UP = Vector2(0, -1)

func _physics_process(delta):
	if state == FREE:
		get_input()
		velocity.y += gravity * delta
		if jumping and is_on_floor():
			jumping = false
		velocity = move_and_slide(velocity, Vector2(0, -1))
		
		if is_on_wall() and ((Input.is_action_pressed("ui_right")) or (Input.is_action_pressed("ui_left"))):
			can_jump = true
			if velocity.y >= 0:
				velocity.y = min(velocity.y + wall_slide_acce, max_wall_speed)
				$AnimatedSprite.play("wallslide")
				if Input.is_action_pressed("ui_right"):
					$AnimatedSprite.flip_h = true
				if Input.is_action_pressed("ui_left"):
					$AnimatedSprite.flip_h = false
			
		if Input.is_action_just_pressed("ui_select"):
			if can_jump:
				velocity.y = jump_speed
				if is_on_wall() and Input.is_action_pressed("ui_right"):
					velocity.x = -run_speed
				elif is_on_wall() and Input.is_action_pressed("ui_left"):
					velocity.x = run_speed
	elif state == IN_LANDER:
		position = get_parent().get_parent().get_node("LunarLander").position
		position.y -= 100
		if Input.is_action_pressed('ui_accept'):
			state = FREE
			$Camera2D.reset_offset()
			$Camera2D.target_zoom = Vector2(1.0, 1.0)
