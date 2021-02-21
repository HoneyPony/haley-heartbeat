extends Node2D

const JUMP_START = 16
const JUMP_END = 35

var home_x = 0
var spawn_y = 0

var target_x_vel

var health: float = 15

func _ready():
	$Anim.playing = true
	$Hit.playing = true
	$Hit.visible = false
	
	home_x = position.x

var OrbBullet = preload("res://CrystalBullet.tscn")
var Explode = preload("res://CrystalExplode.tscn")

var anim_stage = 0

const BTIME = 0.06
var bullet_timer = BTIME

var theta = 0

func _process(delta):
	if position.y > spawn_y:
		position.y -= 300 * delta
		
	if bullet_timer <= 0:
		$Shoot.play()
		
		var bullet = OrbBullet.instance()
		bullet.home_node = $BSpawn
		bullet.theta = theta
		#bullet.velocity = polar2cartesian(700, TAU * theta)
		get_parent().add_child(bullet)
		
		var bullet2 = OrbBullet.instance()
		bullet2.home_node = $BSpawn
		bullet2.theta = theta + 0.5
		#bullet2.velocity = polar2cartesian(-700, TAU * theta)
		get_parent().add_child(bullet2)
		
		bullet_timer = BTIME
	else:
		bullet_timer -= delta
		
	theta += delta / 3.0
	theta = fmod(theta, 1.0)
	

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
