extends KinematicBody2D

var velocity : Vector2
var acceleration : float = 300
var rotationSpeed : float = 4
var shotSpeed: float = 200
var shotCooldown: float = 0.1

onready var shootSound = get_node("AudioStreamPlayer")

export(Resource) var BulletScene

func _ready():
	pass

func _process(delta):
	
	var rotationDir = 0
	var velocity = Vector2.ZERO
	
	#MOVEMENT
	
	if Input.is_action_pressed("ForwardThrust"):
		velocity -= transform.y * acceleration
	
	if Input.is_action_pressed("RotateLeft"):
		rotationDir -= 1
		
	if Input.is_action_pressed("RotateRight"):
		rotationDir += 1
		
	#SHOOTING
	
	if Input.is_action_pressed("Shoot"):
		var bullet = BulletScene.instance()
		shootSound.play()
		owner.add_child(bullet)
		bullet.linear_velocity = direction * shotSpeed + velocity
		bullet.global_position = global_position + (direction * 38)
		#$Timer.start(shotCooldown)
		
	#WORLD TORUS	
		
	if position.x < 0:
		position.x = 1200
		
	if position.x > 1200:
		position.x = 0
		
	if position.y < 0:
		position.y = 800
		
	if position.y > 800:
		position.y = 0
		
	rotation += rotationDir * rotationSpeed * delta
	velocity = move_and_slide(velocity)

func createBullet (direction: Vector2):
	var bullet = BulletScene.instance()
	shootSound.play()
	owner.add_child(bullet)
	bullet.linear_velocity = direction * shotSpeed + velocity
	bullet.global_position = global_position + (direction * 38)

