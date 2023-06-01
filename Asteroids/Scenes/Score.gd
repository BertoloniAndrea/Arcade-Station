extends CanvasLayer

onready var score_label = get_node("Score/Label")
onready var lives_container = get_node("Score/Lives container")
onready var level_label = get_node("Score/Level")
onready var game_over_label = get_node("Score/Game over")

var life_scene = preload("res://Scenes/Life.tscn")
var wrap_after = 5
var last_h_container_index = -1
var last_life_index
var digits = 4

func center_label(label) -> Label:
	label.rect_global_position = OS.window_size/2
	label.rect_global_position.x -= label.rect_size.x/2
	label.rect_global_position.y -= label.rect_size.y/2
	return label

func set_level(level):
	level_label.text = "LEVEL " + str(level)
	level_label = center_label(level_label)
	level_label.visible = true

func set_score(score):
	var score_value = str(score)
	if (score_value.length() > digits):
		digits += 2
	score_value = "0".repeat(digits - score_value.length()) + score_value
	score_label.text = score_value

func add_life():
	if last_h_container_index == -1:
		add_container()
		add_life()
	else:
		var vbox_container = lives_container.get_children()
		var hbox_container = vbox_container[last_h_container_index]
		last_life_index = hbox_container.get_child_count()
#		print(str(last_h_container_index) + " " + str(last_life_index))
		if last_life_index + 1 > wrap_after:
			add_container()
			add_life()
		else:
			hbox_container.add_child(life_scene.instance())

#func remove_life():
#	if last_h_container_index > 0:
#		var vbox_container = lives_container.get_children()
#		var hbox_container = vbox_container[last_h_container_index] as HBoxContainer
#		if last_life_index > 0:
#			var life = hbox_container.get_children()[last_life_index]
#			hbox_container.remove_child(life)
#		else:
#			last_h_container_index -= 1
#			remove_life()

func clear_children():
	for l in lives_container.get_children():
		lives_container.remove_child(l)
		l.queue_free()
	last_h_container_index = -1
	last_life_index = 0
	
func show_game_over_label():
	game_over_label = center_label(game_over_label)
	game_over_label.visible = true

func hide_level_label():
	level_label.visible = false

func add_container():
	lives_container.add_child(HBoxContainer.new())
	last_h_container_index += 1

func _ready():
	score_label.text = "0000"
