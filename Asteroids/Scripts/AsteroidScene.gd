extends Area2D
class_name Asteroid

export var speed := 100.0
var direction := Vector2.ZERO
var asteroid_sprite

func _ready():
	var x = (randf() * 2) - 1
	var y = (randf() * 2) - 1
	direction = Vector2(x, y)
	asteroid_sprite = get_node("Sprite")

func _process(delta):
	position += speed * direction * delta
	pass
	
func set_texture(asteroid_texture):
	get_node("Sprite").texture = asteroid_texture
