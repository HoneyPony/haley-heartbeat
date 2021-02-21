extends Node2D

const JUMP_START = 16
const JUMP_END = 35

var home_x = 0
var spawn_y = 0

var target_x = 0

var target_x_vel

var health: float = 8

func _ready():
	$Anim.playing = true
	$Hit.playing = true
	$Hit.visible = false
	
	home_x = position.x
	target_x = home_x

var Bullet = preload("res://WritingBullet2.tscn")
var Explode = preload("res://BookExplode.tscn")

var anim_stage = 0

var B_TIME = 0.416666666666666
var bullet_timer = B_TIME

var move_timer = 2.0

func bullet(vel):
	var bullet = Bullet.instance()
	bullet.position = position + Vector2(0, -60) 
	bullet.velocity = vel
	get_parent().add_child(bullet)

func _process(delta):
	if position.y > spawn_y:
		position.y -= 300 * delta
		
	if bullet_timer < 0:
		$Shoot.play()
		bullet_timer = B_TIME
		
		bullet(Vector2(-1, -1).normalized() * 700)
		bullet(Vector2(0, -1) * 700)
		bullet(Vector2(1, -1).normalized() * 700)
		#polar2cartesian(rand_range(0, 48), rand_range(0, 6.28))
			
	else:
		bullet_timer -= delta
	
	move_timer -= delta
	if move_timer <= 0:
		move_timer = rand_range(0.7, 2.3)
		target_x = home_x + rand_range(-10, 10)
		
	position.x += (target_x - position.x) * 0.04
		

func _on_hit(body):
	if body.hit_something(self):
		
		$Hit/Anim.play("Flash")
		
		health -= body.damage
		if health <= 0:
			Global.enemy_count -= 1
			
			var ex = Explode.instance()
			ex.position = $Anim.global_position
			get_parent().add_child(ex)
			
			queue_free()
			
		$HitS.play()
