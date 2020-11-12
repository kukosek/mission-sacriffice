extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var player_detection = $PlayerDetection
var velocity = Vector2.ZERO
export (int) var gravity = 1000
export (int) var walk_speed = 150

var positions
var positions_count
var pos_iter = 0

func _ready():
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
func set_veloc_by_target_point(target_pos):
	if target_pos.x - position.x >=0:
		velocity.x = walk_speed
		sprite.flip_h = false
	else:
		velocity.x = -walk_speed
		sprite.flip_h = true

var standing_timer = 0
func _physics_process(delta):
	if player_detection.detected:
		if sprite.animation != "gunshot": sprite.play("gunshot")
	else:
		if positions != null:
			var target = positions[pos_iter]
			var target_pos = target.position
			
			
			if velocity.x == 0:
				standing_timer += delta
			if (velocity.x > 0 and target_pos.x <= position.x) or (velocity.x < 0 and target_pos.x >= position.x):
				velocity.x = 0
				sprite.play("default")
			if standing_timer >= target.stay_time:
				standing_timer = 0
				pos_iter += 1
				if pos_iter >= positions_count:
					pos_iter = 0
				set_veloc_by_target_point(positions[pos_iter].position)
				sprite.play("walking")
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
