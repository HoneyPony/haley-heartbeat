extends Node2D

const JUMP_START = 16
const JUMP_END = 35

var home_x = 0
var spawn_y = 0

var target_x_vel

var health: float = 10

func _ready():
	$Anim.playing = true
	$Hit.playing = true
	$Hit.visible = false
	
	home_x = position.x

var OrbBullet = preload("res://GreenBubbleBullet.tscn")

var anim_stage = 0

var bullet_timer = 1.5

func _process(delta):
	if position.y > spawn_y:
		position.y -= 300 * delta
		
	if bullet_timer < 0.85:
		if randf() < 0.7:
			var bullet = OrbBullet.instance()
			bullet.position = position + Vector2(rand_range(-34, 34), -48) #polar2cartesian(rand_range(0, 48), rand_range(0, 6.28))
			get_parent().add_child(bullet)
	if bullet_timer < 0:
		bullet_timer = 1.5
	else:
		bullet_timer -= delta
	

func _on_hit(body):
	if body.hit_something(self):
		
		$Hit/Anim.play("Flash")
		
		health -= body.damage
		if health <= 0:
			Global.enemy_count -= 1
			queue_free()
