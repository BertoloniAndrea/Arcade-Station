extends KinematicBody2D
const SPEED = 300
var velocity = Vector2.ZERO

func _ready():
	var direction = Vector2(rand_range(4,-1), rand_range(4,0))
	velocity = direction * SPEED

func _process(delta):
	position += velocity * delta
	
	# if position.x < -get_viewport().size.x / 2:
		
 

