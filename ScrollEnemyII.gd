extends Node2D

const JUMP_START = 16
const JUMP_END = 35

var home_x = 0

var target_x_vel

var health: float = 10

func _ready():
	$Anim.playing = true
	$Hit.playing = true
	$Hit.visible = false
	
	home_x = position.x

var OrbBullet = preload("res://GreenSphereBullet.tscn")

var anim_stage = 0

var bullet_timer = 1.0

func _process(delta):
	position.y -= 300 * delta
	
	if $Anim.frame == 0:
		anim_stage = 0
	
	if $Anim.frame == JUMP_START and anim_stage < 1:
		anim_stage = 1
		var target_x = home_x + rand_range(-64, 64)
		# time = 0.833333333333333
		target_x_vel = (target_x - position.x) / 0.83333333333333333333
		
	# 20 * x + 45 * v = 0
	# x = -45 * v / 20
	if $Anim.frame >= JUMP_START and $Anim.frame <= JUMP_END:
		position.y += 675 * delta
		position.x += target_x_vel * delta
		
	if $Anim.frame == JUMP_END and anim_stage < 2:
		anim_stage = 2
		
	if bullet_timer <= 0:
		bullet_timer = rand_range(0.6, 0.9)
		var bullet = OrbBullet.instance()
		bullet.position = position + polar2cartesian(rand_range(0, 48), rand_range(0, 6.28))
		get_parent().add_child(bullet)
	else:
		bullet_timer -= delta
#
#		for i in range(0, rand_range(2, 5)):
#			var bullet = OrbBullet.instance()
#			bullet.position = position + polar2cartesian(rand_range(0, 48), rand_range(0, 6.28))
#			get_parent().add_child(bullet)
		
		

func _on_hit(body):
	if body.hit_something(self):
		
		$Hit/Anim.play("Flash")
		
		health -= body.damage
		if health <= 0:
			queue_free()
