extends Area2D
class_name Saucer

export var linear_velocity := 200.0
export var shot_cooldown := 125.0
var bullet_scene := preload("res://Scenes/BulletScene.tscn")
var path_to_follow: PathFollow2D


func _ready():
	pass

func _physics_process(delta):
	path_to_follow.set_offset(path_to_follow.get_offset() + linear_velocity * delta)


func _on_screen_exited():
	queue_free()
