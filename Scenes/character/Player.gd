extends KinematicBody2D

export (int) var run_speed = 400
export (int) var jump_speed = -350
export (int) var gravity = 1000

var velocity = Vector2()

var jumping = false
var slashing = false
var gunfiring = false

var wall_slide_elaped_time = 0.5

var IN_LANDER = 0
var FREE = 1
var state = IN_LANDER

var MOVING = 1
var WALL_SLIDE = 3
var move_state = MOVING

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			$Laser.fire()
			$AnimatedSprite.frame = 0
			gunfiring = true
			$AnimatedSprite.play("gunshot")

func get_input():
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select' )
	if jump and is_on_floor() and move_state != WALL_SLIDE: 
		jumping = true
		velocity.y = jump_speed
	var slash = Input.is_action_just_pressed("ui_down")
	if slash:
		slashing = true
		if is_on_floor():
			$AnimatedSprite.play("swordswing")
	var knockback = Input.is_action_just_released("ui_down")
	
	if move_state == WALL_SLIDE:
		if jump:
			move_state = MOVING
			$AnimatedSprite.play("jump")
			wall_slide_elaped_time = 0
			jumping = true
			post_jumping = false
			velocity.y = min(velocity.y + wall_slide_acce, max_wall_speed)
		if left and $AnimatedSprite.flip_h == true:
			move_state = MOVING
			wall_slide_elaped_time = 0
			if not jumping and not post_jumping: $AnimatedSprite.play("walking")
		if right and $AnimatedSprite.flip_h == false:
			move_state = MOVING
			wall_slide_elaped_time = 0
			if not jumping and not post_jumping: $AnimatedSprite.play("walking")
	if wall_slide_elaped_time > 0.25:
		if $wall_right.is_colliding():
			$AnimatedSprite.play("wallslide")
			$AnimatedSprite.flip_h = true
			$Laser.update_positions(true)
			move_state = WALL_SLIDE
			jumping = false
		if $wall_left.is_colliding():
			$AnimatedSprite.play("wallslide")
			$AnimatedSprite.flip_h = false
			$Laser.update_positions(false)
			move_state = WALL_SLIDE
			jumping = false
	if move_state == MOVING:
		velocity.x = 0
		if not jumping and not post_jumping and not slashing and not gunfiring:
			if right or left:
				if $AnimatedSprite.animation != "walking":
					$AnimatedSprite.play("walking")
			elif $AnimatedSprite.animation != "default":
				$AnimatedSprite.play("default")
		
		if right:
			$AnimatedSprite.flip_h = false
			$Laser.update_positions(false)
			velocity.x = run_speed
		if left:
			$AnimatedSprite.flip_h = true
			$Laser.update_positions(true)
			velocity.x = -run_speed
		
	if jumping:
		if !is_on_floor() and velocity.y > -100 and $AnimatedSprite.animation != "jump":
			$AnimatedSprite.play("jump")
		if is_on_floor() and velocity.y == 0 and $AnimatedSprite.animation == "jump":
			$AnimatedSprite.play("post_jump")
			if right or left:
				$AnimatedSprite.speed_scale = 2.0
			jumping = false
			post_jumping = true
		
	
export (int) var wall_slide_acce = -10
export (int) var max_wall_speed = -200

func _physics_process(delta):
	if state == FREE:
		get_input()
		
		if move_state != WALL_SLIDE:
			wall_slide_elaped_time += delta
		velocity.y += gravity * delta
		
		velocity = move_and_slide(velocity, Vector2(0, -1))

	elif state == IN_LANDER:
		position = get_parent().get_parent().get_node("LunarLander").position
		position.y -= 100
		if Input.is_action_pressed('ui_accept'):
			state = FREE
			$Camera2D.reset_offset()
			$Camera2D.target_zoom = Vector2(1.0, 1.0)

var post_jumping = false
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "post_jump":
		$AnimatedSprite.speed_scale = 1.0
		$AnimatedSprite.play("default")
		post_jumping = false
	if slashing:
		slashing = false
	if gunfiring:
		gunfiring = false
