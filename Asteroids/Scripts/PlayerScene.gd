extends KinematicBody2D
class_name Player

signal died

export var max_speed := 100.0
export var rotation_speed := 4.0
export var linear_velocity := 15.0
export var friction_factor := 0.5
export var shot_cooldown := 125

enum Rotation {LEFT, NONE, RIGHT}

var save
var is_invincible = false
var controls_enabled = true
var fun = true
var e = exp(1)
var input_vector := Vector2.ZERO 
var rotation_direction: int
var velocity := Vector2.ZERO 
var bullet_scene := preload("res://Scenes/BulletScene.tscn")

onready var thrust_sound = $AudioStreamPlayer2D
onready var animated_sprite = $"AnimatedSprite"
onready var blinking_timer = $"Blinking timer" as Timer
onready var invincibility_timer = $"Invincibility timer" as Timer
onready var viewport = OS.window_size

func _ready():
	rotation_speed = linear_velocity/PI
	#rotation = PI
	#position.x = viewport.x / 2
	#position.y = viewport.y * 0.6

func _process(_delta):
	if (fun):
#		pass
#		thrust_sound.pitch_scale = 0.8 + ((velocity.length_squared())/(velocity.length_squared() + velocity.length() + 1))
#		thrust_sound.pitch_scale = 0.9 + (log(1 + velocity.length()) / log(50))
		thrust_sound.pitch_scale = (velocity.length() + 1) / max_speed + 0.9
		if (not thrust_sound.playing):
#			thrust_sound.volume_db = 0.0
			thrust_sound.play()

	#MOVEMENT
	
	if (controls_enabled):
		input_vector.x = Input.get_action_strength("RotateLeft") - Input.get_action_strength("RotateRight") # Analog stick support
		input_vector.y = Input.get_action_strength("ForwardThrust")
		if Input.is_action_pressed("ForwardThrust"):
			animated_sprite.play("thrusting")
#			if (not thrust_sound.playing):
##			thrust_sound.volume_db = 0.0
#				thrust_sound.play()
		if Input.is_action_just_released("ForwardThrust"):
			animated_sprite.animation = "default"
			animated_sprite.stop()
		if Input.is_action_pressed("RotateLeft"):
			rotation_direction = -1
		elif Input.is_action_pressed("RotateRight"):
			rotation_direction = +1
		else:
			rotation_direction = 0

func _physics_process(delta):
	if (controls_enabled):
		rotation += rotation_direction * rotation_speed * delta
#		print((180/PI) * rotation) 
	#	if (rotation > 2 * PI):
	#		save = rotation - 2 * PI
	#		rotation = save
		if (input_vector.y > 0):
			accelerate(delta)
		elif (input_vector.y == 0 and velocity != Vector2.ZERO):
			decelerate(delta)
		move_and_collide(velocity)

func start_invincibility():
	is_invincible = true
	blinking_timer.start()
	invincibility_timer.start()

func accelerate(delta):
	velocity += (input_vector * linear_velocity * delta).rotated(rotation)
	velocity = velocity.limit_length(max_speed)

func decelerate(delta):
	if (velocity.length() < 0.1):
		velocity = Vector2.ZERO
	velocity = lerp(velocity, Vector2.ZERO, friction_factor * delta) # linearly interpolate speed to zero

func toggle_visibility():
	animated_sprite.visible = !animated_sprite.visible

func stop_invincibility():
	is_invincible = false
	animated_sprite.visible = true
	blinking_timer.stop()
	invincibility_timer.stop()
	
func disable_controls():
	controls_enabled = false
	#reset_movement()
	
func reset_movement():
	rotation_direction = 0
	velocity = Vector2.ZERO
	animated_sprite.play("default")
	animated_sprite.stop()
	
func enable_controls():
	controls_enabled = true
