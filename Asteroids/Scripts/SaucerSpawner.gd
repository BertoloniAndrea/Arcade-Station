extends Node
class_name SaucerSpawner


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var saucer_scene = preload("res://Scenes/SaucerScene.tscn")
onready var saucer_timer = get_node("Timer") as SaucerTimer
var top_path
var bottom_path
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	top_path = get_node("Path Top/PathFollow2D")
	bottom_path = get_node("Path Bottom/PathFollow2D")
	
	spawn_saucer()
	rng.randomize()
	saucer_timer.connect("timeout", self, "spawn_saucer")
	
func spawn_saucer():
	var saucer = saucer_scene.instance() as Saucer

	var path_to_follow = top_path if rng.randf() > 0.5 else bottom_path
	#var path_to_follow = top_path
	
	if path_to_follow.get_child_count() > 0:
		return
		
	saucer.path_to_follow = path_to_follow
	path_to_follow.add_child(saucer)
	saucer_timer.setup_timer()
	saucer_timer.start()
