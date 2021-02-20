extends Node2D

var needs_to_go_again = false

func _process(delta):
	position.y -= 300 * delta
	if position.y < -500:
		if needs_to_go_again:
			position.y += 1500
			needs_to_go_again = false
		else:
			Global.tutorial.f_cond_jump_pit = true
			queue_free()
		
func hit():
	pass

func y():
	return $End.global_position.y
	
func center():
	needs_to_go_again = true
	return $Center.global_position.y
