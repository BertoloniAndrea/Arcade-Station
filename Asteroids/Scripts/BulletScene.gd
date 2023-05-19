extends KinematicBody2D

export var linear_velocity := 100.0
var vertical_movement := Vector2(0, 1)

func _ready():
	pass
 
func _process(delta):
	move_and_slide((vertical_movement * linear_velocity * delta).rotated(get_parent().rotation))
	
	if position.x < 0:
		position.x = 1200

	if position.x > 1200:
		position.x = 0

	if position.y < 0:
		position.y = 800

	if position.y > 800:
		position.y = 0

func _init(player_position, player_rotation):
	position = player_position
	rotation = player_rotation
	
func set_rotation(player_rotation):
	rotation = player_rotation
