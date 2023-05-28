extends Node2D

var bullet_scene := preload("res://Scenes/BulletScene.tscn")

onready var shoot_sound = $AudioStreamPlayer
onready var shooting_timer = $ShootingTimer
var can_shoot = false

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("Shoot"):
		if (can_shoot):
			shoot_sound.play()			
			var bullet = bullet_scene.instance() as Bullet
			bullet.set_position(global_position)
			bullet.set_rotation(get_parent().rotation)
			get_tree().root.add_child(bullet)
			can_shoot = true


func _on_ShootingTimer_timeout():
	can_shoot = true
