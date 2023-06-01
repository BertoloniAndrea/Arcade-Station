extends Timer
class_name SaucerTimer

export var min_time = 0
export var max_time = 1
var _rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	_rng.randomize()
	setup_timer()

func setup_timer():
	self.wait_time = _rng.randf_range(min_time, max_time)
	self.start()
