extends Node

export var safe_margin = 100.0
export (float, 0, 180) var distance_factor = 30.0
export (int, 0, 10) var asteroid_count = 20

onready var player = get_node("Player")
onready var asteroid_container = get_node("Asteroid container")
onready var asteroid_spawner = get_node("Asteroid spawner") as AsteroidSpawner
onready var hud = get_node("HUD")
var asteroid
var score = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(asteroid_count):
		asteroid = asteroid_spawner.generate_random_asteroid()
		asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
		asteroid_container.add_child(asteroid)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	if Input.is_action_just_pressed("Restart"):
		load_new_scene("res://Scenes/GameScene.tscn")
	
	
func load_new_scene(scene_path: String):
	var packed_scene = load(scene_path) as PackedScene
	var new_scene = packed_scene.instance()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.call_deferred("queue_free")
	get_tree().current_scene = new_scene
	
func on_asteroid_destroyed(size, position: Vector2, rotation):
	match(size):
		AsteroidSize.AsteroidSize.SMALL:
			score += 100
			hud.set_score(score)
			return
		AsteroidSize.AsteroidSize.NORMAL:
			score += 50
			size = AsteroidSize.AsteroidSize.SMALL
		AsteroidSize.AsteroidSize.BIG:
			score += 20
			size = AsteroidSize.AsteroidSize.NORMAL
	hud.set_score(score)
	spawn_asteroid(size, position, rotation + (distance_factor * PI / 180))
	spawn_asteroid(size, position, rotation - (distance_factor * PI / 180))

func spawn_asteroid(size, position, rotation):
	asteroid = asteroid_spawner.spawn_asteroid(size, position, rotation)
	asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
	asteroid_container.add_child(asteroid)
