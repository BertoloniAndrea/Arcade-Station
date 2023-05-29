extends Area2D
class_name Asteroid

signal on_asteroid_destroyed(size, position, rotation)
signal score(score)

onready var destroy_sound = get_node("AudioStreamPlayer2D")
export(AudioStream) var player_died_stream 
export var speed := 125.0
var vertical_movement := Vector2(0, 1)
var rotation_factor
var asteroid_sprite
var asteroid_collision_shape
var size
var scale_value
var destroyed = false

const Utils = preload("res://Scripts/Utils/AsteroidSize.gd")

func _ready():
	match(size):
		AsteroidSize.AsteroidSize.SMALL:
			scale_value = 1.0
		AsteroidSize.AsteroidSize.NORMAL:
			scale_value = 1.5
		AsteroidSize.AsteroidSize.BIG:
			scale_value = 2.0
	destroy_sound.stream = player_died_stream
	asteroid_sprite = get_node("Sprite")
	asteroid_collision_shape = get_node("CollisionShape2D")
	asteroid_sprite.scale = Vector2(scale_value, scale_value)
	asteroid_collision_shape.scale = Vector2(scale_value + 1, scale_value + 1)
	
func _process(delta):
	asteroid_sprite.rotation += (PI/180) * rotation_factor * delta
	position += (speed * vertical_movement / asteroid_sprite.scale * delta).rotated(rotation)
	
func set_texture(asteroid_texture):
	get_node("Sprite").texture = asteroid_texture

func on_body_entered(body):
	if body is Player:
		if (!(body as Player).is_invincible):
			destroy_sound.play()
			body.emit_signal("died")
			body.call_deferred("queue_free")

func on_destroy(body_rotation = rotation):
	if (not destroyed):
		emit_signal("on_asteroid_destroyed", size, position, body_rotation)
	call_deferred("queue_free")


func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func _on_area_entered(area):
	if area is Bullet:
		area.call_deferred("queue_free")
		on_destroy(area.rotation)
