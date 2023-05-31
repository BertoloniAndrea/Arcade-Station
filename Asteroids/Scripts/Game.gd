extends Node

signal teleport_finished

export var safe_margin = 200.0
export (float, 0, 180) var distance_factor = 30.0
export (int, 0, 10) var initial_asteroid_count = 7
export(int, 0, 10) var lives = 8

var player_scene = preload("res://Scenes/PlayerScene.tscn")
onready var player = get_node("Player")

onready var viewport = OS.window_size

onready var asteroid_container = get_node("Asteroid container")
onready var asteroid_spawner = get_node("Asteroid spawner") as AsteroidSpawner
onready var hud = get_node("HUD")
onready var level_timer = get_node("Level timer")

onready var destroy_sound = get_node("AudioStreamPlayer2D")
onready var small_asteroid_stream = load("res://Assets/Sounds/SmallAsteroidExplosion.wav")
onready var normal_asteroid_stream = load("res://Assets/Sounds/MediumAsteroidExplosion.wav")
onready var big_asteroid_stream = load("res://Assets/Sounds/BigAsteroidExplosion.wav")

var starting_position
var player_is_teleporting = false
var asteroid
var score = 0
var level = 0
var asteroid_count = 0
var target = PI
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	move_to_new_level()
#	start_new_game(0)
	player.connect("died", self, "life_manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if (player_is_teleporting):
		if (player.rotation < 0):
			print("negative")
			target = -PI
		else:
			print("positive")
			target = PI
		teleport_player(delta)
	if (asteroid_container.get_child_count() == 0):

		move_to_new_level()
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
	else:
		player.call_deferred("queue_free")
		hud.show_game_over_label()

func move_to_new_level():
	level += 1
	asteroid_count = initial_asteroid_count + pow(level, 2)
	hud.set_level(level)
	level_timer.start()
	start_new_game(asteroid_count)

func start_new_game(count):
	starting_position = Vector2(OS.window_size.x/2, OS.window_size.y * 0.6)
	hud.clear_children()
	
	for _life in range(lives):
		hud.add_life()

	initialize_player()
	
	for _i in range(count):
#		while true:
		asteroid = asteroid_spawner.generate_random_asteroid()
#			if (asteroid.position.distance_to(player.position) > safe_margin):
#				break
		asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
		asteroid_container.add_child(asteroid)
		
func initialize_player():
	player.reset_movement()
	player.disable_controls()
	player.is_invincible = true
	player_is_teleporting = true


func teleport_player(delta):
	if player.position.distance_to(starting_position) < 0.5 && abs(player.rotation - target) < 0.01:
		player_is_teleporting = false
		player.start_invincibility()
		player.enable_controls()
	
	player.position = lerp(player.position, starting_position, delta * 6)
	player.rotation = lerp(player.rotation, target, delta * 6)
#	print(str((180/PI) * player.rotation) + str(target)) 
func spawn_asteroid(size, position, rotation):
	asteroid = asteroid_spawner.spawn_asteroid(size, position, rotation)
	asteroid.connect("on_asteroid_destroyed", self, "on_asteroid_destroyed")
	asteroid_container.call_deferred("add_child", asteroid)


func _on_level_timer_timeout():
	hud.hide_level_label()
