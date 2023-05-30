extends Node

export var safe_margin = 200.0
export (float, 0, 180) var distance_factor = 30.0
export (int, 0, 10) var asteroid_count = 7
export(int, 0, 10) var lives = 8

var player_scene = preload("res://Scenes/PlayerScene.tscn")
onready var player = get_node("Player")
var starting_position

onready var viewport = OS.window_size

onready var asteroid_container = get_node("Asteroid container")
onready var asteroid_spawner = get_node("Asteroid spawner") as AsteroidSpawner
onready var hud = get_node("HUD")

onready var destroy_sound = get_node("AudioStreamPlayer2D")
onready var small_asteroid_stream = load("res://Assets/Sounds/SmallAsteroidExplosion.wav")
onready var normal_asteroid_stream = load("res://Assets/Sounds/MediumAsteroidExplosion.wav")
onready var big_asteroid_stream = load("res://Assets/Sounds/BigAsteroidExplosion.wav")

var asteroid
var score = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_new_game(true, false)
	player.connect("died", self, "life_manager")
#	player.connect("died", self, "life_manager")
#	for _i in range(asteroid_count):
#		asteroid = asteroid_spawner.generate_random_asteroid()
#		asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
#		asteroid_container.add_child(asteroid)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if (asteroid_container.get_child_count() == 0):
		move_to_new_level(delta)
		#start_new_game()
	if Input.is_action_just_pressed("Restart"):
		load_new_scene("res://Scenes/GameScene.tscn")
	
	
func load_new_scene(scene_path: String):
	var packed_scene = load(scene_path) as PackedScene
	var new_scene = packed_scene.instance()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.call_deferred("queue_free")
	get_tree().current_scene = new_scene
	
func on_asteroid_destroyed(size, position: Vector2, rotation):
	if (size != AsteroidSize.AsteroidSize.SMALL):
		match(size):
			AsteroidSize.AsteroidSize.NORMAL:
				score += 50
				size = AsteroidSize.AsteroidSize.SMALL
				destroy_sound.stream = normal_asteroid_stream
			AsteroidSize.AsteroidSize.BIG:
				score += 20
				size = AsteroidSize.AsteroidSize.NORMAL
				destroy_sound.stream = big_asteroid_stream
			_:
				destroy_sound.stream = big_asteroid_stream

		spawn_asteroid(size, position, rotation + (distance_factor * PI / 180))
		spawn_asteroid(size, position, rotation - (distance_factor * PI / 180))
		destroy_sound.play()
	else:
		destroy_sound.stream = small_asteroid_stream
		destroy_sound.play()
		score += 100	
	hud.set_score(score)
	
func life_manager():
	lives -= 1
	hud.clear_children()
	if lives > 0:
		for _life in range(lives):
			hud.add_life()
		initialize_player()

func start_new_game(level, move_to_new_level = false):
	starting_position = Vector2(OS.window_size.x/2, OS.window_size.y * 0.6)

	hud.clear_children()
	for _life in range(lives):
		hud.add_life()

	initialize_player()
	
	for _i in range(asteroid_count):
		while true:
			asteroid = asteroid_spawner.generate_random_asteroid()
			if (asteroid.position.distance_to(player.position) > safe_margin):
				break
		asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
		asteroid_container.add_child(asteroid)
		
func initialize_player():
	player.position = starting_position
	player.start_invincibility()
	player.enable_controls()

func move_to_new_level(delta):
	var lerp_finished = false
	player.disable_controls()
	if player.position.distance_to(starting_position) < 0.5 && abs(player.rotation - PI) < 0.5:
		lerp_finished = true
	if (!lerp_finished):
		player.position = lerp(player.position, starting_position, delta * 4)
		player.rotation = lerp(player.rotation, PI, delta * 4)
	else:
		start_new_game(true, true)

func spawn_asteroid(size, position, rotation):
	asteroid = asteroid_spawner.spawn_asteroid(size, position, rotation)
	asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
	asteroid_container.call_deferred("add_child", asteroid)
