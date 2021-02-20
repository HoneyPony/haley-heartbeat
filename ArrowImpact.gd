extends Node2D

onready var spr = $Sprite

const MAX_L = 1.2
var lifetime = MAX_L

func _ready():
	spr.rotation_degrees = rand_range(0, 360)
	$SpawnParticles.emitting = true
	var color_dif = rand_range(0, 1)
	spr.modulate.g -= color_dif
	spr.modulate.b -= color_dif
	
func _process(delta):
	position.y -= 300 * delta
	
	lifetime -= delta
	spr.scale = Vector2(1, 1) * max((lifetime - 0.9) / 0.3, 0.0)
	
	if lifetime <= 0:
		queue_free()
