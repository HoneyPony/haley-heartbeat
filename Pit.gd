extends Node2D

func _ready():
	position.y = 1060
	
var has_reduced_count = false

func _process(delta):
	position.y -= 300 * delta
	if position.y < -500:
		
		queue_free()
	if position.y < 600:
		if not has_reduced_count:
			Global.enemy_count -= 1
			has_reduced_count = true
		
func hit():
	pass

func y():
	return $End.global_position.y
	
func center():
	return $Center.global_position.y
