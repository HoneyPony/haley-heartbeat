extends TileMap

func _physics_process(delta):
	position.y -= 300 * delta
	
	var mod_1024 = fposmod(position.y, 1024)
	position.y = mod_1024 - 1024
