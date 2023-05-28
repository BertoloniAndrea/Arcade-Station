extends CanvasLayer

onready var label = get_node("Score/Label")
var digits = 4

func set_score(score):
	var score_value = str(score)
	if (score_value.length() > digits):
		digits += 1
	score_value = "0".repeat(digits - score_value.length()) + score_value
	label.text = score_value

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "0000"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
