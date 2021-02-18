extends Sprite

var lifetime = 5

func _physics_process(delta):
	position.y -= 300 * delta
	
	lifetime -= delta
	if lifetime < 0:
		queue_free()
