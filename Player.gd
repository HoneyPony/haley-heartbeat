extends Node2D

var velocity: Vector2 = Vector2.ZERO

var top_y = 0

var tutorial_invincible = false

const ACCEL = 2400
const MAXVEL = 400

const HEALTHBAR_MAX = 175

const HEALTH_MAX = 20
var health = HEALTH_MAX

onready var healthbar = get_node("../../Layer/HealthbarHealth")

func set_health_prop(f):
	healthbar.region_rect.position.x = (1.0 - f) * HEALTHBAR_MAX

func get_input_vector():
	var input = Vector2.ZERO
	
	if Input.is_action_pressed("player_left"):
		input.x = -1
	if Input.is_action_pressed("player_right"):
		input.x = 1
		
	if Input.is_action_pressed("player_up"):
		input.y = -1
	if Input.is_action_pressed("player_down"):
		input.y = 1
		
	var joy = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	if joy.length() > 0.3:
		input += joy
		
	if input != Vector2.ZERO:
		Global.tutorial.f_cond_move = true
		
	return input

onready var heart = get_node("../../Layer/Heartbeat")
	
var BasicArrow = preload("res://BasicArrow.tscn")
var BasicArrowII = preload("res://BasicArrowII.tscn")
var BasicArrowIII = preload("res://BasicArrowIII.tscn")
var BasicArrowIV = preload("res://BasicArrowIV.tscn")
	
var shoot_timer = 0

func beats2arrow():
	if heartbeats == 4:
		return BasicArrowIV
	if heartbeats == 3:
		return BasicArrowIII
	if heartbeats == 2:
		return BasicArrowII
	return BasicArrow

func beats2damage():
	if heartbeats == 0:
		return 1
	if heartbeats == 1:
		return 1.2
	if heartbeats == 2:
		return 1.5
	if heartbeats == 3:
		return 1.8
	if heartbeats == 4:
		return 2

func try_shoot(reset_heartbeats = false):
	if jump_timer > 0:
		return
	
	if shoot_timer <= 0:
		if reset_heartbeats:
			heartbeats = 0
		
		shoot_timer = 0.27
		
		var arrow = beats2arrow().instance()
		arrow.damage = beats2damage()
		arrow.position = $ShootSpawn.global_position
		get_parent().add_child(arrow)
		
		Global.tutorial.f_cond_shoot = true
		return true
		
	return false
	
func play_heart():
	if heartbeats == 1:
		heart.play_sfx($Heart1)
	if heartbeats == 2:
		heart.play_sfx($Heart2)
	if heartbeats == 3:
		heart.play_sfx($Heart3)
	if heartbeats == 4:
		heart.play_sfx($Heart4)
	
var heartbeats = 0
	
func shoot_process(delta):
	var anim_shoot = shoot_timer > 0
	
	if Input.is_action_just_pressed("player_fire"):
		if heart.is_on_beat():
			#modulate = Color.red
			heart.get_node("ShockAnim").play("Shock")
			heartbeats += 1
			if heartbeats > 4:
				heartbeats = 1
				
			play_heart()
		else:
			heartbeats = 0
		try_shoot()
	elif Input.is_action_pressed("player_fire"):
		if try_shoot(true):
			anim_shoot = true
	else:
		if shoot_timer < -0.5:
			heartbeats = 0
			
#	reset_time = clamp(reset_time - delta, 0.0, 1.0)
#	if reset_time <= 0:
#		modulate = Color.white
		
	shoot_timer = clamp(shoot_timer - delta, -3, 1.0)
	
	$Walk.visible = not anim_shoot
	$WalkShoot.visible = anim_shoot
	
#onready var camera = get_node("../../Camera")
	
var jump_timer = 0

enum State {
	Normal,
	Fall
}

var state = State.Normal

var respawn_point = Vector2.ZERO
var fall_dy = 0

func process_fall(delta):
	position.y -= 260 * delta
	fall_dy -= 300 * delta
	
	scale -= Vector2(1, 1) * 2 * delta
	if scale.x <= 0.2:
		scale = Vector2(1, 1)
		position = respawn_point + Vector2(0, fall_dy)
		state = State.Normal
		$Fall.hide()
	
onready var default_col = $Harm.collision_layer
onready var default_mask = $Harm.collision_mask
	
func _physics_process(delta):
	if jump_timer > 0:
		$Harm.collision_layer = 0
		$Harm.collision_mask = 0
	else:
		$Harm.collision_layer = default_col
		$Harm.collision_mask = default_mask
	
	if state == State.Fall:
		process_fall(delta)
		return
#	top_y += 300 * delta
	#position.y += 300 * delta
	
	var input = get_input_vector()
	
	var target_velocity = input.normalized() * MAXVEL
	# This technically is framerate-dependent, but it's hard to do better
	# meh who needs velocity smoooth... just don't bother for now
	#velocity += (target_velocity - velocity) * 0.2
	
	position += target_velocity * delta
	
	position.y = clamp(position.y, top_y + 32, top_y + 960 - 32)
	
	shoot_process(delta)
	
	#camera.position.y = top_y
	
	if Input.is_action_just_pressed("player_jump"):
		if jump_timer <= 0:
			jump_timer = 0.75
			$Walk.hide()
			$WalkShoot.hide()
			$Jump.show()
			$Jump.frame = 0
			$Jump.play()
			
			
	if jump_timer > 0:
		$Walk.hide()
		$WalkShoot.hide()
		$Jump.show()
		jump_timer -= delta
	else:
		$Jump.hide()
		
	set_health_prop(health / HEALTH_MAX)
	health = min(health + delta * 0.2, HEALTH_MAX)
		
var Shoeprint = preload("res://Shoeprint.tscn")
		
func shoe(v):
	var s = Shoeprint.instance()
	s.position = v.global_position
	get_parent().add_child(s)
		
func shoe_right():
	shoe($ShoeRight)
	
func shoe_left():
	shoe($ShoeLeft)
	
func restore_health():
	health = 20
	
func take_health(amount):
	if tutorial_invincible and health - amount <= 0:
		return
	
	health -= amount

func _on_hit(body):
	if jump_timer > 0:
		return
	
	if body.hit_something(self):
		
		take_health(1)
		
func _on_pit(area):
	if jump_timer > 0:
		return
		
	area.get_parent().hit()
	take_health(3)
	
	respawn_point = Vector2(position.x, area.get_parent().y())
	state = State.Fall
	
	position.y = area.get_parent().center()
	
	$Fall.frame = 0
	$Fall.play()
	$Fall.show()
	$Walk.hide()
	$WalkShoot.hide()
	$Jump.hide()
	fall_dy = 0
