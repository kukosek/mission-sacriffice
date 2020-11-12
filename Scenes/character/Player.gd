extends KinematicBody2D

export (int) var run_speed = 400
export (int) var jump_speed = -350
export (int) var gravity = 1000

var velocity = Vector2()

var in_lander = false
var jumping = false
var slashing = false
var gunfiring = false
var wallsliding = false

var wall_slide_elaped_time = 0.5


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			$Laser.fire()
			$AnimatedSprite.frame = 0
			gunfiring = true
			$AnimatedSprite.play("gunshot")
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func right_colliding():
	return $wall_right_up.is_colliding() and $wall_right_down.is_colliding()

func left_colliding():
	return $wall_left_up.is_colliding() and $wall_left_down.is_colliding()

func get_input():
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select' )
	if jump and is_on_floor() and not wallsliding: 
		jumping = true
		velocity.y = jump_speed
	var slash = Input.is_action_just_pressed("ui_down")
	if slash:
		slashing = true
		if is_on_floor():
			$AnimatedSprite.play("swordswing")
	var knockback = Input.is_action_just_released("ui_down")
	
	if wallsliding:
		if jump:
			wallsliding = false
			$AnimatedSprite.play("jump")
			wall_slide_elaped_time = 0
			jumping = true
			post_jumping = false
			velocity.y = min(velocity.y + wall_slide_acce, max_wall_speed)
		if $AnimatedSprite.flip_h == true:
			if not right_colliding():
				wallsliding = false
				jumping = true
				wall_slide_elaped_time = 0
				$AnimatedSprite.play("jump")
			elif left:
				wallsliding = false
				wall_slide_elaped_time = 0
				if not jumping and not post_jumping: $AnimatedSprite.play("walking")
		if $AnimatedSprite.flip_h == false:
			if not left_colliding():
				wallsliding = false
				jumping = true
				wall_slide_elaped_time = 0
				$AnimatedSprite.play("jump")
			elif right:
				wallsliding = false
				wall_slide_elaped_time = 0
				if not jumping and not post_jumping: $AnimatedSprite.play("walking")
	if wall_slide_elaped_time > 0.25:
		if right_colliding():
			$AnimatedSprite.play("wallslide")
			$AnimatedSprite.flip_h = true
			$Laser.update_positions(true)
			wallsliding = true
			jumping = false
		if left_colliding():
			$AnimatedSprite.play("wallslide")
			$AnimatedSprite.flip_h = false
			$Laser.update_positions(false)
			wallsliding = true
			jumping = false
	if not wallsliding:
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
	if not in_lander:  
		get_input()
		
		if not wallsliding:
			wall_slide_elaped_time += delta
		velocity.y += gravity * delta
		
		velocity = move_and_slide(velocity, Vector2(0, -1))

	

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
