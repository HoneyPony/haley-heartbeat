extends Node2D

func _process(delta):
	position.y -= 300 * delta
	if position.y < -500:
		position.y += 1500
		#queue_free()
		
func hit():
	pass

func y():
	return $End.global_position.y
	
func center():
	return $Center.global_position.y
