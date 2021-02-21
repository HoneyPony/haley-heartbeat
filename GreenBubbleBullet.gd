extends KinematicBody2D

var velocity = Vector2.ZERO

var is_deleting = false

var lifetime = 3
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
	
onready var player = get_node("../Player")
	
func _ready():
	target_offset = polar2cartesian(rand_range(0, 72), rand_range(0, TAU))
	
	velocity = Vector2(0, -100)
	
	

func target():
	return player.position + target_offset
	
func target_v():
	return (target() - position).normalized()

func _physics_process(delta):
	var s = $Sprite.scale.x
	s += 10 * delta
	if s > 1:
		s = 1
		
	if lifetime <= 0.3:
		s = lifetime / 0.3
		
	velocity.y = velocity.y - 600 * delta
	velocity.y = clamp(velocity.y, -400, 0)
		
	$Sprite.scale.x = s
	$Sprite.scale.y = s
	
	position += velocity * delta
	
	lifetime -= delta
	if lifetime <= 0:
		delete()
	
	
