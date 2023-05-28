extends Node

var viewport
var wrapArea = null
var spriteSize
var halfSpriteSize


# Dictionary of axis directions
var AXIS = {
	HORIZONTAL = "x",
	VERTICAL = "y"
}

# Initialise the wrap area to screen size if not set
func initWrapArea():
	viewport = OS.window_size
	if wrapArea == null:
		wrapArea = Rect2(Vector2.ZERO, viewport + halfSpriteSize)

# When node ready, set the inital wrap area if not set
func _ready():
	var sprite = get_parent().get_node("Sprite")
	spriteSize = sprite.get_texture().get_size() * sprite.scale
	halfSpriteSize = spriteSize / 2
	initWrapArea()

# Check whether the parent object is NOT in the wrap area,
# call the wrap function if it isn't
func _process(delta):
	#viewport = OS.window_size
	#wrapArea = Rect2(Vector2.ZERO, viewport + halfSpriteSize)
	if !wrapArea.has_point(get_parent().global_position):
		wrap()

# The parent Node is NOT in wrap area, so it must be wrapped
# around until it is
func wrap():
	wrapBy(AXIS.HORIZONTAL)
	wrapBy(AXIS.VERTICAL)

# Function to determine which side of the axis the parent has fallen off
# i.e. the left or right (x axis) or up or down (y axis)
# Return an integer for the direction the wrap is requred in
# the direction is multiplied by the gap (i.e. width or height
# ..and is added to the current axis position
#
# For example:
#   say the screen is 1024 wide
#     zero indexed, so pixels 0 to 1023
#
#   say the sprite has gone off right (at 1024 pixel)
#   We want to subtract 1024 from 1024
#     to position sprite to the left border at 0
# 
# This also work in the opposite direction, for example:
#   say the sprite has gone off left (at pixel -1)
#   We want to add 1024 to the -1
#     to position the sprite to the right border at 1023
#
func getAxisWrapDirection(axis):
	if get_parent().global_position[axis] < wrapArea.position[axis] - halfSpriteSize[axis]:
		# off left/top therefore we want to add width or height
		return 1
	elif get_parent().global_position[axis] > wrapArea.size[axis] + halfSpriteSize[axis]:
		# off left/top therefore we want to subtract width or height
		return -1
	return 0

# Perform the wrap on the parent object
func wrapBy(axis):
	# Calculate the axis adjustment required
	# I.e. get axis wrap direction and multiply by axis size
	var direction = getAxisWrapDirection(axis)
	var adjust = direction * wrapArea.size[axis]
	# Apply the adjustment to the parent's position
	get_parent().position[axis] += adjust + direction * spriteSize[axis]
