extends Node
class_name AsteroidSpawner


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var safe_margin := 100.0
var asteroid_scene := preload("res://Scenes/AsteroidScene.tscn")
var asteroid_textures_locations := [
						"res://Assets/Asteroid/Asteroid1.png",
						"res://Assets/Asteroid/Asteroid2.png",
						"res://Assets/Asteroid/Asteroid3.png"
						]
var asteroid_textures := []
var viewport
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	viewport = get_viewport().size
	for texture_location in asteroid_textures_locations:
		asteroid_textures.append(load(texture_location))
	for i in range(8):
		generate_random_asteroid()

func generate_random_asteroid():
	var asteroid = asteroid_scene.instance() as Asteroid
	while true:
		var x = rng.randi_range(0, viewport.x)
		var y = rng.randi_range(0, viewport.y)
		print(x + y)
		if (true):
			asteroid.position = Vector2(x, y)
			var asteroid_texture_index = rng.randi_range(0, asteroid_textures.size() - 1)
			var asteroid_texture = asteroid_textures[asteroid_texture_index]
			asteroid.set_texture(asteroid_texture)
			add_child(asteroid)
			break

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
