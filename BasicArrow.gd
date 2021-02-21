extends Node2D

var velocity = 400

var is_deleting = false

var lifetime = 15
var damage: float = 1

export var piercing = 1

var beat = false

func delete():
	if is_deleting:
		return
		
	is_deleting = true
	queue_free()
	
var things_ive_hit = []

var ArrowImpact = preload("res://ArrowImpact.tscn")

func hit_something(what):
	if what in things_ive_hit:
		return false
		
	things_ive_hit.append(what)
	piercing -= 1
	if piercing <= 0:
		delete()
		
	var imp = ArrowImpact.instance()
	imp.position = global_position
	get_parent().add_child(imp)
	
	return true
	
func _ready():
	if beat:
		$Shoot/Beat.play()
	else:
		$Shoot.play()

func _process(delta):
	position.y += velocity * delta
	velocity += 1200 * delta
	
	position.y -= 300 * delta
	
	lifetime -= delta
	if lifetime <= 0:
		delete()
	
	
