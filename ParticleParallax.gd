extends CPUParticles2D

func _physics_process(delta):
	position.y -= 300 * delta
