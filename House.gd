extends Node2D

func _ready():
	position = Vector2(0, 960 + 524)
	
func _process(delta):
	position.y -= 300 * delta
