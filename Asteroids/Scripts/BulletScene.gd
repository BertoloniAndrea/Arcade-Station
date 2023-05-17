extends KinematicBody2D

var velocity: Vector2 = Vector2(0, 0)
var bulletSpeed = 200

func _ready():
	pass
 

func _process(delta):
	
	velocity -= transform.y * bulletSpeed
	
	if position.x < 0:
		position.x = 1200
		
	if position.x > 1200:
		position.x = 0
		
	if position.y < 0:
		position.y = 800
		
	if position.y > 800:
		position.y = 0

	velocity = move_and_slide(velocity)
