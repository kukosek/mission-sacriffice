extends KinematicBody2D

export (int) var run_speed = 400
export (int) var jump_speed = -350
export (int) var gravity = 1000

var velocity = Vector2()

var in_lander = true
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
	if event is InputEventKey:
		if event.pressed:
			if event.is_action_pressed("ui_select"):
				if is_on_floor() and not wallsliding: 
					jumping = true
					velocity.y = jump_speed
				if wallsliding:
					wallsliding = false
					$AnimatedSprite.play("jump")
					wall_slide_elaped_time = 0
					jumping = true
					post_jumping = false
					velocity.y = min(velocity.y + wall_slide_acce, max_wall_speed)
			if event.is_action_pressed("ui_down"):
				slashing = true
				if is_on_floor():
					$AnimatedSprite.play("swordswing")
			if event.is_action_pressed("ui_right"):
				if wallsliding and $AnimatedSprite.flip_h == false:
					wallsliding = false
					wall_slide_elaped_time = 0
					if not jumping and not post_jumping: $AnimatedSprite.play("walking")
				if not jumping and not post_jumping and not slashing and not gunfiring and not wallsliding and $AnimatedSprite.animation != "walking":
					$AnimatedSprite.play("walking")
				$AnimatedSprite.flip_h = false
				$Laser.update_positions(false)
				velocity.x = run_speed
			if event.is_action_pressed("ui_left"):
				if wallsliding and $AnimatedSprite.flip_h == true:
					wallsliding = false
					wall_slide_elaped_time = 0
					if not jumping and not post_jumping: $AnimatedSprite.play("walking")
				if not jumping and not post_jumping and not slashing and not gunfiring and not wallsliding and $AnimatedSprite.animation != "walking":
					$AnimatedSprite.play("walking")
				$AnimatedSprite.flip_h = true
				$Laser.update_positions(true)
				velocity.x = -run_speed
		else:
			var right = event.is_action_released("ui_right")
			var left = event.is_action_released("ui_left")
			var already_running_to_another_side = (right and velocity.x < 0) or (left and velocity.x > 0)
			if (right or left) and not already_running_to_another_side:
				velocity.x = 0
				if not jumping and not post_jumping and not slashing and not gunfiring and not wallsliding and $AnimatedSprite.animation != "default":
					$AnimatedSprite.play("default")
func right_colliding():
	return $wall_right_up.is_colliding() and $wall_right_down.is_colliding()

func left_colliding():
	return $wall_left_up.is_colliding() and $wall_left_down.is_colliding()

func get_input():
	if wallsliding:
		if $AnimatedSprite.flip_h == true:
			if not right_colliding():
				wallsliding = false
				jumping = true
				wall_slide_elaped_time = 0
				$AnimatedSprite.play("jumping")
		if $AnimatedSprite.flip_h == false:
			if not left_colliding():
				wallsliding = false
				jumping = true
				wall_slide_elaped_time = 0
				$AnimatedSprite.play("jumping")
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

		
	if jumping:
		if !is_on_floor() and velocity.y > -100 and $AnimatedSprite.animation != "jump":
			$AnimatedSprite.play("jump")
		if is_on_floor() and velocity.y == 0 and $AnimatedSprite.animation == "jump":
			$AnimatedSprite.play("post_jump")
			if Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left'):
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

	else:
		position = get_parent().get_parent().get_node("LunarLander").position
		position.y -= 100
		if Input.is_action_pressed('ui_accept'):
			in_lander = false
			$Camera2D.reset_offset()
			$Camera2D.target_zoom = Vector2(1.0, 1.0)

var post_jumping = false
func _on_AnimatedSprite_animation_finished():
	var walking = Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left')
	if $AnimatedSprite.animation == "post_jump":
		$AnimatedSprite.speed_scale = 1.0
		if walking:
			$AnimatedSprite.play("walking")
		else:
			$AnimatedSprite.play("default")
		post_jumping = false
	if slashing:
		slashing = false
		if walking:
			$AnimatedSprite.play("walking")
		else:
			$AnimatedSprite.play("default")
	if gunfiring:
		gunfiring = false
		if walking:
			$AnimatedSprite.play("walking")
		else:
			$AnimatedSprite.play("default")
