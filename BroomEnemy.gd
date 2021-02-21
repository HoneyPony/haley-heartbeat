extends Node2D

const JUMP_START = 16
const JUMP_END = 35

var home_x = 0
var spawn_y = 0

var target_x_vel

var health: float = 12

func _ready():
	$Anim.playing = true
	$Hit.playing = true
	$Hit.visible = false
	
	home_x = position.x

var OrbBullet = preload("res://BroomBullet.tscn")
var Explode = preload("res://BroomExplode.tscn")

var anim_stage = 0

const BTIME = 1.4
var bullet_timer = BTIME

var theta = 0

func _process(delta):
	if position.y > spawn_y:
		position.y -= 300 * delta
		
	if bullet_timer <= 0:
		$Shoot.play()
		
		for i in range(0, 90):
			var bullet = OrbBullet.instance()
			bullet.position = $BSpawn.global_position
			bullet.velocity = polar2cartesian(700, deg2rad(i * 4))
			get_parent().add_child(bullet)
		
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
