extends KinematicBody2D

onready var sprite = $AnimatedSprite
var player_detection
var velocity = Vector2.ZERO
export (int) var gravity = 1000
export (int) var walk_speed = 150
export (int) var enemy_vision = 500

var positions
var positions_count
var pos_iter = 0

export (int) var damage = 1
export (int) var hp = 3

var dead = false

var damage_blinking = false
var damage_blink_time = 0.1
var damage_blink_remaining = 0.0

func die():
	dead = true
	sprite.play("death")
	set_collision_layer_bit(3, false)
	set_collision_mask_bit(3, false)
	if not get_parent().name in Global.dead_enemy_names:
		Global.dead_enemy_names.append(get_parent().name)
func damage(damage_hp):
	if hp > 0:
		damage_blinking = true
		sprite.modulate.r = 0.0
		damage_blink_remaining = damage_blink_time
		hp -= damage_hp
	if hp <= 0:
		die()
func _ready():
	if not get_parent().name in Global.dead_enemy_names:
		player_detection = load("res://Scenes/enemy/PlayerDetection.tscn").instance()
		player_detection.enemy_vision = enemy_vision
		add_child(player_detection)
		gun_sound_player = AudioStreamPlayer.new()
		gun_sound_player.stream = pre_fire_sound
		add_child(gun_sound_player)
		add_child(tween)
		var follow_positions_group_node = get_parent().get_node_or_null("FollowPositions")
		if follow_positions_group_node == null:
			positions = null
		else:
			positions = follow_positions_group_node.get_children()
			positions_count = len(positions)
			if positions_count == 0:
				positions = null
			else:
				set_veloc_by_target_point(positions[0].position)
		sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	else:
		die()
func set_veloc_by_target_point(target_pos):
	if target_pos.x - position.x >=0:
		velocity.x = walk_speed
		sprite.flip_h = false
	else:
		velocity.x = -walk_speed
		sprite.flip_h = true

onready var tween = Tween.new()


export (PackedScene) onready var projectile_res = load("res://Scenes/enemy/Projectile.tscn")
var gun_sound_player
export (AudioStreamOGGVorbis) onready var pre_fire_sound = load("res://Scenes/enemy/enemy1/pre_gunshot.ogg")
var firing = false
func pre_fire():
	gun_sound_player.play()
	firing = true
	sprite.play("gunshot")
	tween.interpolate_callback(self, 0.25, "fire_projectile")
	tween.start()

func fire_projectile():
	if !dead:
		var projectile = projectile_res.instance()
		get_parent().add_child(projectile)
		var projectile_body = projectile.get_node("Projectile")
		projectile_body.damage = damage
		projectile_body.position = position
		projectile_body.position.y -= 15
		projectile_body.fire(!sprite.flip_h)
	else:
		firing = false

var standing_timer = 0
func _physics_process(delta):
	if damage_blinking:
		if damage_blink_remaining > 0:
			damage_blink_remaining -= delta
		else:
			damage_blinking = false
			sprite.modulate.r = 1.0
	if not dead:
		if player_detection.detected:
			if player_detection.right:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
			velocity.x = 0
			if !firing: pre_fire()
		elif !firing:
			if positions != null:
				var target = positions[pos_iter]
				var target_pos = target.position
				
				
				if velocity.x == 0:
					standing_timer += delta
				if (velocity.x > 0 and target_pos.x <= position.x) or (velocity.x < 0 and target_pos.x >= position.x):
					velocity.x = 0
					if sprite.animation != "default": sprite.play("default")
				if standing_timer >= target.stay_time:
					standing_timer = 0
					pos_iter += 1
					if pos_iter >= positions_count:
						pos_iter = 0
					set_veloc_by_target_point(positions[pos_iter].position)
					if sprite.animation != "walking": sprite.play("walking")
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))



func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "gunshot":
		firing = false;
		sprite.play("default")
