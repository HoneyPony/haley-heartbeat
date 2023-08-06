extends Node2D

var velocity: Vector2 = Vector2.ZERO

var top_y = 0

var tutorial_invincible = false

export var health_invincible = false

const ACCEL = 2400
const BASE_MAXVEL = 400
var MAXVEL = 400

const HEALTHBAR_MAX = 175

const BASE_HEALTH_MAX = 7
var HEALTH_MAX = 7
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

func beats2arrow(on_beat = true):
	# Forgiving mechanics:
	# Your bullet level isn't reset if you shoot not-on-beat.
	# However, when you do shoot not-on-beat, your arrow is
	# reset to the default for that shot.
	if not on_beat:
		return BasicArrow
	
	if heartbeats == 4:
		return BasicArrowIV
	if heartbeats == 3:
		return BasicArrowIII
	if heartbeats == 2:
		return BasicArrowII
	return BasicArrow

func beats2damage(on_beat = true):
	if not on_beat:
		return 1
	
	if heartbeats == 0:
		return 1.1 # Slightly better than off-beat for when
		# the first arrow is on-beat
	if heartbeats == 1:
		return 1.2
	if heartbeats == 2:
		return 1.5
	if heartbeats == 3:
		return 1.8
	if heartbeats == 4:
		return 2

func try_shoot(reset_heartbeats = false, on_beat = false):
	if jump_timer > 0:
		return
	
	if shoot_timer <= 0:
		if reset_heartbeats:
			heartbeats = 0
		
		shoot_timer = 0.27
		
		var arrow = beats2arrow(on_beat).instance()
		arrow.beat = on_beat
		arrow.damage = beats2damage(on_beat)
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
			try_shoot(false, true)
		else:
			heartbeats = 0
		
	if Input.is_action_pressed("player_fire"):
		if try_shoot(false, false):
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
	if scale.x <= 0:
		scale.x = 0
		scale.y = 0
	if health <= 0:
		return
	if scale.x <= 0.2:
		scale = Vector2(1, 1)
		position = respawn_point + Vector2(0, fall_dy)
		state = State.Normal
		$Fall.hide()
		health_invincible = true
		$AnimationPlayer.play("Invincible")
	
onready var default_col = $Harm.collision_layer
onready var default_mask = $Harm.collision_mask
	
var lose_time = -1

onready var LoseScreen = load("res://LoseScreen.tscn")
onready var audio_bus = AudioServer.get_bus_index("GameMusic")

func _ready():
	HEALTH_MAX = BASE_HEALTH_MAX * Global.game_opts["health"]
	health = HEALTH_MAX
	
	MAXVEL = BASE_MAXVEL * Global.game_opts["speed"]
	
	AudioServer.set_bus_volume_db(audio_bus, 0)
	
	if Global.level == 0:
		tutorial_invincible = true

func _physics_process(delta):
	$Sprite.visible = state != State.Fall
	
	if lose_time > 0:
		$Walk.hide()
		$Fall.visible = state == State.Fall
		$WalkShoot.hide()
		$Jump.hide()
		
		$Flop.visible = state != State.Fall
		
		if state == State.Fall:
			process_fall(delta)
		
		
		lose_time -= delta
		var db = AudioServer.get_bus_volume_db(audio_bus) - 10 * delta
		db = clamp(db, -80, 0)
		AudioServer.set_bus_volume_db(audio_bus, db)
		if lose_time <= 0:
			get_node("../../Transition").transition_to(LoseScreen, get_parent().get_parent())
			lose_time = 100
		return
	
	if jump_timer > 0 or health_invincible or Global.opt_invinc:
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
			
			$Jump2.play()
			
			
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
	if health < 0:
		if lose_time < -0.5:
			$Walk.hide()
			$Fall.hide()
			$WalkShoot.hide()
			$Jump.hide()
			$Flop.visible = state != State.Fall
			$Flop.play()
			$OwBig.play()
			lose_time = 1
		
		set_health_prop(0)
		return
	
	
	

func _on_hit(body):
	if Global.opt_invinc:
		return
	if health_invincible:
		return
	if jump_timer > 0:
		return
	
	if body.hit_something(self):
		$Ow.play()
		take_health(1)
		health_invincible = true
		$AnimationPlayer.play("Invincible")
		
func _on_pit(area):
	if Global.opt_invinc:
		return
	if health_invincible:
		return
	if jump_timer > 0:
		return
		
	area.get_parent().hit()
	take_health(2)
	
	respawn_point = Vector2(position.x, area.get_parent().y())
	state = State.Fall
	
	position.y = area.get_parent().center()
	
	$Fall.frame = 0
	$Fall.play()
	$Fall.show()
	$Walk.hide()
	$WalkShoot.hide()
	$Jump.hide()
	$OwVerb.play()
	fall_dy = 0
