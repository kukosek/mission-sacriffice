extends Node2D

var region_rect = Rect2(0,0, 0,0)
var default_size_x

func _ready():
	$Sprite.region_enabled = true
	region_rect.size.y = $Sprite.texture.get_size().y
	default_size_x = $Sprite.texture.get_size().x
	region_rect.size.x = default_size_x
	
	$Sprite.region_rect = region_rect

func update_positions(flipped):
	if flipped:
		rotation_degrees = 180
	else:
		rotation_degrees = 0

func fire():
	$AnimationPlayer.stop()
	visible = true
	$RayCast2D.enabled = true
	$AnimationPlayer.play("shoot")
	$AudioStreamPlayer2D.play()

func _process(delta):
	if $RayCast2D.is_colliding():
		var collide_point = $RayCast2D.get_collision_point()
		region_rect.size.x = abs($RayCast2D.global_position.x - collide_point.x) * 16
	else:
		region_rect.size.x = default_size_x
	$Sprite.region_rect = region_rect
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shoot":
		visible = false
		$RayCast2D.enabled = false
