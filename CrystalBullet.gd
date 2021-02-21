extends KinematicBody2D

var velocity = Vector2.ZERO

var is_deleting = false

var lifetime = 1.5
var aim_time = 2

var accel
var target_offset

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
	
var theta = 0
var radius = 0
var home_node = null
var home_position

#var offset = Vector2.ZERO

func _physics_process(delta):
	#offset.y -= delta * 300
	
	if home_node != null:
		home_position = home_node.global_position
		
	position = polar2cartesian(radius, theta * TAU) + home_position
	theta += delta / 3.0
	theta = fmod(theta, 1.0)
	
	radius += 400 * delta
	
	lifetime -= delta
	if lifetime <= 0.2:
		$CollisionShape2D.disabled = true
	
	if lifetime <= 0:
		delete()
		
	var s = $Sprite.scale.x
	s += 10 * delta
	if s > 1:
		s = 1
		
	if lifetime <= 0.3:
		s = lifetime / 0.3
		
	$Sprite.scale.x = s
	$Sprite.scale.y = s
	
	
