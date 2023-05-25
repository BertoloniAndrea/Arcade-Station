extends Node

func _process(delta):
	if Input.is_action_just_pressed("Restart"):
		load_new_scene("res://Scenes/MainScene.tscn")
	
	
func load_new_scene(scene_path: String):
	var packed_scene = load(scene_path) as PackedScene
	var new_scene = packed_scene.instance()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.call_deferred("queue_free")
	get_tree().current_scene = new_scene
