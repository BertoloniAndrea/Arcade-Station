extends Area2D
class_name Asteroid

signal on_asteroid_destroyed(size, position, rotation)
signal score(score)

export var speed := 125.0
onready var destroy_sound = $AudioStreamPlayer2D
var vertical_movement := Vector2(0, 1)
var rotation_factor
var asteroid_sprite
var asteroid_collision_shape
var size
var scale_value

const Utils = preload("res://Scripts/Utils/AsteroidSize.gd")

func _ready():
	match(size):
		AsteroidSize.AsteroidSize.SMALL:
			scale_value = 1.0
		AsteroidSize.AsteroidSize.NORMAL:
			scale_value = 1.5
		AsteroidSize.AsteroidSize.BIG:
			scale_value = 2.0
	asteroid_sprite = get_node("Sprite")
	asteroid_collision_shape = get_node("CollisionShape2D")
	asteroid_sprite.scale = Vector2(scale_value, scale_value)
	asteroid_collision_shape.scale = Vector2(scale_value + 1, scale_value + 1)
func _process(delta):
	asteroid_sprite.rotation += (PI/180) * rotation_factor * delta
	position += (speed * vertical_movement / asteroid_sprite.scale * delta).rotated(rotation)
	pass
	
func set_texture(asteroid_texture):
	get_node("Sprite").texture = asteroid_texture

func on_body_entered(body):
	if body is Player:
		pass
		#body.call_deferred("queue_free")
		#on_destroy() 

func on_destroy(body_rotation = rotation):
	destroy_sound.play()
	call_deferred("queue_free")
	emit_signal("on_asteroid_destroyed", size, position, body_rotation)
	
#	if (size != AsteroidSize.AsteroidSize.SMALL):
#		emit_signal("on_asteroid_destroyed", size, position, body_rotation)

func _on_area_entered(area):
	destroy_sound.play()
	if area is Bullet:
		area.call_deferred("queue_free")
		on_destroy(area.rotation)
