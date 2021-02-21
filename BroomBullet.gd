extends KinematicBody2D

var velocity = Vector2.ZERO

var is_deleting = false

var lifetime = 5

func delete():
	if is_deleting:
		return
		
	is_deleting = true
	queue_free()

var things_ive_hit = []
var piercing = 1

func hit_something(what):
	if what in things_ive_hit:
		return false
		
	things_ive_hit.append(what)
	piercing -= 1
	if piercing <= 0:
		delete()
	
	return true
	
func _physics_process(delta):		
	position += velocity * delta
	
	lifetime -= delta
	if lifetime <= 0.2:
		$CollisionShape2D.disabled = true
	
	if lifetime <= 0:
		delete()
	
	
