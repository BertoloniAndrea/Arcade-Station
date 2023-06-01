extends Node2D

var bullet_scene := preload("res://Scenes/BulletScene.tscn")

onready var shoot_sound = $AudioStreamPlayer
onready var shooting_timer = $ShootingTimer
var can_shoot = false

func _ready():
	pass

func _process(_delta):
	if Input.is_action_pressed("Shoot"):
		if (can_shoot): #can_shoot
			shooting_timer.start()
			shoot_sound.play()
			var bullet = bullet_scene.instance() as Bullet
			bullet.set_position(global_position)
			bullet.set_rotation(get_parent().rotation)
			bullet.set_velocity(get_parent().velocity.length()*50)
			get_tree().root.add_child(bullet)
			can_shoot = false
			

func _on_ShootingTimer_timeout():
	can_shoot = true
