extends KinematicBody2D
class_name Bullet

export var linear_velocity := 100000.0
var vertical_movement := Vector2(0, 1)

func _ready():
	pass
 
func _process(delta):
	move_and_slide((vertical_movement * linear_velocity * delta).rotated(rotation))
	
func set_rotation(player_rotation):
	rotation = player_rotation
	
func set_position(player_position):
	position = player_position
