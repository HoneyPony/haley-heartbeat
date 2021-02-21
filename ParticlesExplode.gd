extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lifetime = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles.emitting = true
	
func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
