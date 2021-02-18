extends Node2D

var velocity = 400

var is_deleting = false

var lifetime = 15
var damage: float = 1

export var piercing = 1

func delete():
	if is_deleting:
		return
		
	is_deleting = true
	queue_free()
	
var things_ive_hit = []

func hit_something(what):
	if what in things_ive_hit:
		return false
		
	things_ive_hit.append(what)
	piercing -= 1
	if piercing <= 0:
		delete()
	
	return true

func _process(delta):
	position.y += velocity * delta
	velocity += 1200 * delta
	
	position.y -= 300 * delta
	
	lifetime -= delta
	if lifetime <= 0:
		delete()
	
	
