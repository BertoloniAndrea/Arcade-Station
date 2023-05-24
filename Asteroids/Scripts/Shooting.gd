extends Node2D

var bullet_scene := preload("res://Scenes/BulletScene.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Shoot"):
		var bullet = bullet_scene.instance() as Bullet
		bullet.set_position(global_position)
		bullet.set_rotation(get_parent().rotation)
		get_tree().root.add_child(bullet)
	pass
