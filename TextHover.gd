extends Control

var time = 0

onready var base = rect_position.y
onready var basex = rect_position.x
#
#func wind():
#	return sin(time * 0.12) * 3
	
func _process(delta):
#	rect_position.y = base + wind()
#	time += delta
	if randf() < 0.03:
		rect_position.y = base + rand_range(-2, 2)
	if randf() < 0.03:
		rect_position.x = basex + rand_range(-2, 2)
