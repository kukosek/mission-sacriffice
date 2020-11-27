extends Node2D

var region_rect = Rect2(0,0, 0,0)
var default_size_x

onready var sprite = $Sprite
onready var raycast = $RayCast2D
onready var raycast_walls = $RayCast2DOnlyWall
onready var collision_area = $Area2D

func _ready():
	collision_area.monitoring = false
	sprite.region_enabled = true
	region_rect.size.y = sprite.texture.get_size().y
	default_size_x = sprite.texture.get_size().x
	region_rect.size.x = default_size_x
	
	sprite.region_rect = region_rect

func update_positions(flipped):
	if flipped:
		rotation_degrees = 180
	else:
		rotation_degrees = 0

func fire():
	$AnimationPlayer.stop()
	visible = true
	collision_area.monitoring = false
	collision_area.monitoring = true
	raycast.enabled = true
	
	$AnimationPlayer.play("shoot")
	$AudioStreamPlayer2D.play()

func _process(delta):
	if raycast.is_colliding():
		var collide_point_glob = raycast.get_collision_point()
		var collide_point = Vector2(abs(raycast.global_position.x - collide_point_glob.x), collide_point_glob.y)
		region_rect.size.x = collide_point.x * 16
	else:
		region_rect.size.x = default_size_x
	sprite.region_rect = region_rect
	
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shoot":
		visible = false
		collision_area.monitoring = false
		raycast.enabled = false


func _on_Area2D_body_entered(body):
	var in_sight = true
	if raycast_walls.is_colliding():
		var collide_point_glob = raycast_walls.get_collision_point()
		var collide_point = Vector2(abs(raycast_walls.global_position.x - collide_point_glob.x), collide_point_glob.y)
		var body_position = Vector2(abs(raycast_walls.global_position.x - body.position.x), body.position.y)

		if body_position.x > collide_point.x:
			in_sight = false
	if in_sight:
		body.damage(1)
