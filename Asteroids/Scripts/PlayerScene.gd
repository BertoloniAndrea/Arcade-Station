extends KinematicBody2D
class_name Player

export var max_speed := 100.0
export var rotation_speed := 2.5
export var linear_velocity := 20.0
export var friction_factor := 0.5
export var shot_cooldown := 125
enum Rotation {LEFT, NONE, RIGHT}

var input_vector := Vector2.ZERO 
var rotation_direction: int
var velocity := Vector2.ZERO 
# var shotSpeed := 200
var bullet_scene := preload("res://Scenes/BulletScene.tscn")
var shoot_cooldown := 0.1

onready var shootSound = get_node("AudioStreamPlayer")

export(Resource) var BulletScene

func _ready():
	pass

func _process(_delta):
	input_vector.x = Input.get_action_strength("RotateLeft") - Input.get_action_strength("RotateRight") # Analog stick support
	input_vector.y = Input.get_action_strength("ForwardThrust")

	var rotationDir = 0
	
	#MOVEMENT
	
	if Input.is_action_pressed("RotateLeft"):
		rotation_direction = -1
	elif Input.is_action_pressed("RotateRight"):
		rotation_direction = +1
	else:
		rotation_direction = 0
		
	#SHOOTING
	
	if Input.is_action_pressed("Shoot"):
		shoot()
		
	#WORLD TORUS	
		
#	if position.x < 0:
#		position.x = 1200
#
#	if position.x > 1200:
#		position.x = 0
#
#	if position.y < 0:
#		position.y = 800
#
#	if position.y > 800:
#		position.y = 0
##
	#rotation += rotationDir * rotationSpeed * delta
	#velocity = move_and_slide(velocity)
	
func _physics_process(delta):
	rotation += rotation_direction * rotation_speed * delta
	if (input_vector.y > 0):
		accelerate(delta)
	elif (input_vector.y == 0 and velocity != Vector2.ZERO):
		decelerate(delta)
	move_and_collide(velocity)
	
func accelerate(delta):
	velocity += (input_vector * linear_velocity * delta).rotated(rotation)
	velocity.limit_length(max_speed)

func decelerate(delta):
	if (velocity.length() < 0.001):
		velocity = Vector2.ZERO
	velocity = lerp(velocity, Vector2.ZERO, friction_factor * delta) # linearly interpolate speed to zero

func shoot():
	pass
#	var bullet = bullet_scene.instance() as Bullet
#	bullet.set_rotation(rotation)
#	bullet.set_position(position + get_node("Sprite").get_texture().get_size() / 2)
#	get_tree().root.add_child(bullet)
#	shootSound.play()
#	$Timer.start(shot_cooldown)
