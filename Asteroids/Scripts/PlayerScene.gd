extends KinematicBody2D
class_name Player

signal died

export var max_speed := 100.0
export var rotation_speed := 4.0
export var linear_velocity := 20.0
export var friction_factor := 0.5
export var shot_cooldown := 125
enum Rotation {LEFT, NONE, RIGHT}

var fun = true
var e = exp(1)
var input_vector := Vector2.ZERO 
var rotation_direction: int
var velocity := Vector2.ZERO 
# var shotSpeed := 200
var bullet_scene := preload("res://Scenes/BulletScene.tscn")
onready var thrust_sound = $AudioStreamPlayer2D
onready var animated_sprite = $AnimatedSprite
export(Resource) var BulletScene

func _ready():
	pass

func _process(_delta):
	input_vector.x = Input.get_action_strength("RotateLeft") - Input.get_action_strength("RotateRight") # Analog stick support
	input_vector.y = Input.get_action_strength("ForwardThrust")
	if (fun):
		thrust_sound.pitch_scale = log(e + velocity.length())
		if (not thrust_sound.playing):
			thrust_sound.volume_db = 0.0
			thrust_sound.play()

	#MOVEMENT
	
	if Input.is_action_pressed("ForwardThrust"):
		if (not thrust_sound.playing):
			thrust_sound.volume_db = 0.0
			thrust_sound.play()
		animated_sprite.play("thrusting")
	if Input.is_action_just_released("ForwardThrust"):
		animated_sprite.animation = "default"
		animated_sprite.stop()
		if (!fun):
			thrust_sound.volume_db = -80.0
		#thrust_sound.stop()
	
	if Input.is_action_pressed("RotateLeft"):
		rotation_direction = -1
	elif Input.is_action_pressed("RotateRight"):
		rotation_direction = +1
	else:
		rotation_direction = 0
	
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
