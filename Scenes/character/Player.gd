extends KinematicBody2D

# This file is bad. Dont read it . the code is evil and will confuse your mind for your entire life

export (int) var run_speed = 400
export (int) var jump_speed = -350
export (int) var gravity = 1000

export (int) var fall_sfx_base_volume = -10
export (int) var fall_sfx_max_volume = 1

export (float) var laser_cooldown_time = 0.6
export (float) var fireball_cooldown_time = 1.0

var laser_cooldown_remaining = 0.0
var fireball_cooldown_remaining = 0.0

const FIREBALL = preload("res://Scenes/character/fireball/fireball.tscn")

var velocity = Vector2()

var in_lander = false
var jumping = false
var jumping_sliding = false
var slashing = false
var gunfiring = false
var wallsliding = false
var crouching = false

onready var scene_name = get_tree().get_current_scene().get_name()

var wall_slide_elaped_time = 0.5

onready var wall_up = $wall_up
onready var collision = $CollisionShape2D
onready var sprite = $AnimatedSprite
onready var hearts = $HUD/MarginContainer/Hearts
onready var death_screen = $HUD/DeathScreen
onready var pause_screen = $HUD/PauseScreen

var stop_crouching = false
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !dead:
		if event.pressed and (not crouching or (crouching and not wall_up.is_colliding())):
			if laser_cooldown_remaining <= 0:
				laser_cooldown_remaining = laser_cooldown_time
				if crouching:
					stop_crouching = true
				$Laser.fire()
				sprite.frame = 0
				gunfiring = true
				sprite.play("gunshot")
	if event is InputEventKey:
		if event.is_action_pressed("ui_crouch"):
			if sprite.animation == "walking" or sprite.animation == "default":
				collision.disabled = true
				crouching = true
				walk_sfx.playing = false
				sprite.play("crouch")
		if event.is_action_released("ui_crouch"):
			stop_crouching = true
			
var dead = false
func die():
	velocity.x = 0
	$Camera2D.target_zoom = Vector2(0.8, 0.8)
	sprite.play("death")
	dead = true
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	jump_sfx.playing = false
	walk_sfx.playing = false

onready var damage_audio_player = $DamageSFX
func damage(damage_hp):
	if !dead:
		damage_audio_player.play()
		for _i in range(damage_hp):
			var hearts_elems = hearts.get_children()
			if len(hearts_elems) > 0:
				hearts.remove_child(hearts_elems[-1])
			hearts_elems = hearts.get_children()
			if len(hearts_elems) == 0:
				die()

func stop_crouching():
	stop_crouching = false
	crouching = false
	collision.disabled = false
	if abs(velocity.x) > 0:
		sprite.play("walking")
		walk_sfx.play()

func right_colliding():
	if scene_name == "Moon":
		return $wall_right_up.is_colliding() and $wall_right_down.is_colliding()
	else:
		return $wall_right_up.is_colliding() or $wall_right_down.is_colliding()

func left_colliding():
	if scene_name == "Moon":
		return $wall_left_up.is_colliding() and $wall_left_down.is_colliding()
	else:
		return $wall_left_up.is_colliding() or $wall_left_down.is_colliding()

func start_walking():
	jump_sfx.playing = false
	if crouching:
		sprite.play("crouch")
	else:
		sprite.play("walking")
	walk_sfx.play()

func stop_walking():
	if crouching:
		sprite.play("crouch")
	else:
		sprite.play("default")
	walk_sfx.playing = false
	jump_sfx.playing = false

var jump_max_fall_speed = 0
func start_jump():
	if not crouching:
		collision.disabled = false
		jumping = true
		walk_sfx.playing = false
		jump_sfx.play()
		jump_max_fall_speed = 0

onready var sword_sfx = $SwordSFX
onready var walk_sfx = $WalkSFX
onready var fall_sfx = $FallSFX
onready var jump_sfx = $JumpSFX
onready var sword_enemy_detector = $SwordEnemyDetect
var can_jump_from_wall = false
func get_input():
	if !dead:
		var right = Input.is_action_pressed('ui_right')
		var left = Input.is_action_pressed('ui_left')
		var jump = Input.is_action_just_pressed('ui_select' )
		if jump and is_on_floor() and not wallsliding: 
			start_jump()
			velocity.y = jump_speed
			
		var slash = Input.is_action_just_pressed("ui_down")
		
		
		if slash and not slashing:
			slashing = true
			if is_on_floor() and (not crouching or (crouching and not wall_up.is_colliding())):
				if crouching:
					stop_crouching = true
				sprite.play("swordswing")
				sword_sfx.play()
				sword_enemy_detector.damage_enemies()
		if Input.is_action_just_pressed("ui_focus_next") and (not crouching or (crouching and not wall_up.is_colliding())):
			if fireball_cooldown_remaining <= 0:
				fireball_cooldown_remaining = fireball_cooldown_time
				if crouching:
					stop_crouching = true
				var fireball = FIREBALL.instance()
				fireball.set_fireball_direction(sprite.flip_h)
				get_parent().add_child(fireball)
				fireball.position = position
			
		
		
		if wallsliding:
			if jump and can_jump_from_wall:
				can_jump_from_wall = false
				jumping_sliding = true
				
				velocity.y = min(velocity.y + wall_slide_acce, max_wall_speed)
			if jumping_sliding and ((!sprite.flip_h and right) or (sprite.flip_h and left)):
				jumping_sliding = false
				wallsliding = false
				wall_slide_elaped_time = 0
				if not is_on_floor():
					sprite.play("jump")
					
					start_jump()
					post_jumping = false
			if sprite.flip_h == true:
				if not right_colliding():
					wallsliding = false
					start_jump()
					wall_slide_elaped_time = 0
					sprite.play("jump")
				elif left:
					wallsliding = false
					wall_slide_elaped_time = 0
					if not jumping and not post_jumping:
						sprite.play("jump")
						start_jump()
			if sprite.flip_h == false:
				if not left_colliding():
					wallsliding = false
					start_jump()
					wall_slide_elaped_time = 0
					sprite.play("jump")
				elif right:
					wallsliding = false
					wall_slide_elaped_time = 0
					if not jumping and not post_jumping:
						sprite.play("jump")
						start_jump()
		elif wall_slide_elaped_time > 0.25 and not post_jumping and not crouching:
			if right_colliding():
				sprite.play("wallslide")
				sprite.flip_h = true
				sword_enemy_detector.side_right = false
				$Laser.update_positions(true)
				wallsliding = true
				can_jump_from_wall = true
				jumping = false
			if left_colliding():
				sprite.play("wallslide")
				sprite.flip_h = false
				sword_enemy_detector.side_right = true
				$Laser.update_positions(false)
				wallsliding = true
				can_jump_from_wall = true
				jumping = false
		if not wallsliding:
			velocity.x = 0
			if not jumping and not post_jumping and not slashing and not gunfiring:
				if velocity.y < 10:
					if right or left:
						if sprite.animation != "walking" and sprite.animation != "crouch":
							start_walking()
					elif sprite.animation != "default":
						stop_walking()
				else:
					start_jump()
			if right:
				sprite.flip_h = false
				sword_enemy_detector.side_right = true
				$Laser.update_positions(false)
				velocity.x = run_speed
				if crouching: velocity.x /= 2
			if left:
				sprite.flip_h = true
				sword_enemy_detector.side_right = false
				$Laser.update_positions(true)
				velocity.x = -run_speed
				if crouching: velocity.x /= 2
			if stop_crouching and not wall_up.is_colliding():
				stop_crouching()
		if jumping:
			if velocity.y > jump_max_fall_speed:
				jump_max_fall_speed = velocity.y
			if !is_on_floor() and velocity.y > -1 and sprite.animation != "jump":
				sprite.play("jump")
			if is_on_floor() and velocity.y == 0 and sprite.animation == "jump":
				sprite.play("post_jump")
				
				fall_sfx.volume_db = fall_sfx_base_volume + (jump_max_fall_speed-200)/25
				if fall_sfx.volume_db > fall_sfx_max_volume:
					fall_sfx.volume_db = fall_sfx_max_volume
				fall_sfx.play()
				jump_sfx.playing = false
				if right or left:
					sprite.speed_scale = 2.0
				jumping = false
				post_jumping = true
		
	
export (int) var wall_slide_acce = -10
export (int) var max_wall_speed = -200

func _physics_process(delta):
	if not in_lander:  
		if laser_cooldown_remaining > 0:
			laser_cooldown_remaining -= delta
		if fireball_cooldown_remaining > 0:
			fireball_cooldown_remaining -= delta
		get_input()
		
		if not wallsliding:
			wall_slide_elaped_time += delta
		velocity.y += gravity * delta
		
		velocity = move_and_slide(velocity, Vector2(0, -1))

	

var post_jumping = false
func _on_AnimatedSprite_animation_finished():
	if not dead:
		if sprite.animation == "post_jump":
			sprite.speed_scale = 1.0
			stop_walking()
			post_jumping = false
		if slashing:
			slashing = false
			if abs(velocity.x) > 0:
				start_walking()
			else:
				stop_walking() 
			if post_jumping:
				sprite.speed_scale = 1.0
				stop_walking()
				post_jumping = false
		if gunfiring:
			gunfiring = false
			if wallsliding:
				sprite.play("wallslide")
			if post_jumping:
				sprite.speed_scale = 1.0
				stop_walking()
				post_jumping = false
	if sprite.animation == "death":
		death_screen.show()
		
