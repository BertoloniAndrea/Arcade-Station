extends Area2D
class_name Asteroid

signal on_asteroid_destroyed(size, position, rotation)

export var speed := 100.0
var vertical_movement := Vector2(0, 1)
var rotation_factor
var asteroid_sprite
var asteroid_collision_shape
var scale_value

const Utils = preload("res://Scripts/Utils/AsteroidSize.gd")

func _ready():
	var x = (randf() * 2) - 1
	var y = (randf() * 2) - 1
	asteroid_sprite = get_node("Sprite")
	asteroid_collision_shape = get_node("CollisionShape2D")
	asteroid_sprite.scale = Vector2(scale_value + 1, scale_value + 1)
	asteroid_collision_shape.scale = Vector2(scale_value + 1, scale_value + 1)
func _process(delta):
	asteroid_sprite.rotation += (PI/180) * rotation_factor * delta
	position += (speed * vertical_movement / asteroid_sprite.scale * delta).rotated(rotation)
	pass

func _physics_process(delta):
	#if is_on_wa;;
	pass
	
func set_texture(asteroid_texture):
	get_node("Sprite").texture = asteroid_texture

func on_body_entered(body):
	if body is Player:
		body.queue_free()
		on_destroy() 

func on_destroy(body_rotation = rotation):
	queue_free()
	if (scale_value > 0):
		emit_signal("on_asteroid_destroyed", scale_value - 1, position, body_rotation)

func _on_area_entered(area):
	if area is Bullet:
		area.queue_free()
		on_destroy(area.rotation)
