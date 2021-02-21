extends Node

func scroll1(time, position):
	return [0, time, position]
	
func scroll2(time, position):
	return [1, time, position]
	
func cauldron(time, position):
	return [2, time, position]
	
func book(time, position):
	return [3, time, position]
	
func crystal(time, position):
	return [4, time, position]
	
var wave = null
var waveset = null
var wave_index = -1
var wave_time = 0

onready var ysort = get_node("../YSort")

var ScrollI = preload("res://ScrollEnemy.tscn")
var ScrollII = preload("res://ScrollEnemyII.tscn")
var Cauldron = preload("res://CauldronEnemy.tscn")
var Book = preload("res://BookEnemy.tscn")
var Crystal = preload("res://CrystalEnemy.tscn")

var win_timer = -1

func spawn_scroll1(position):
	var s = ScrollI.instance()
	s.position.x = position.x
	s.position.y = 1060
	s.spawn_y = position.y
	ysort.add_child(s)
	
func spawn_scroll2(position):
	var s = ScrollII.instance()
	s.position.x = position.x
	s.position.y = 1060
	s.spawn_y = position.y
	ysort.add_child(s)
	
func spawn_cauldron(position):
	var s = Cauldron.instance()
	s.position.x = position.x
	s.position.y = 1060
	s.spawn_y = position.y
	ysort.add_child(s)
	
func spawn_book(position):
	var s = Book.instance()
	s.position.x = position.x
	s.position.y = 1060
	s.spawn_y = position.y
	ysort.add_child(s)
	
func spawn_crystal(position):
	var s = Crystal.instance()
	s.position.x = position.x
	s.position.y = 1060
	s.spawn_y = position.y
	ysort.add_child(s)
	
func spawn(what):
	if what[0] == 0:
		spawn_scroll1(what[2])
	if what[0] == 1:
		spawn_scroll2(what[2])
	if what[0] == 2:
		spawn_cauldron(what[2])
	if what[0] == 3:
		spawn_book(what[2])
	if what[0] == 4:
		spawn_crystal(what[2])
		
func _ready():
	if Global.level == 1:
		waveset = level1
	if Global.level == 2:
		waveset = level2
	if Global.level == 3:
		waveset = level3
	if Global.level == 4:
		waveset = level4
		
	next_wave()
		
func send_wave(a_wave):
	wave = a_wave
	wave_time = 0
	
	Global.enemy_count = wave.size()
	
func next_wave():
	if waveset == null:
		return
	
	wave_index += 1
	if wave_index < waveset.size():
		send_wave(waveset[wave_index])
		
	else:
		win_timer = 3

onready var WinScreen = load("res://WinScreen.tscn")
onready var audio_bus = AudioServer.get_bus_index("GameMusic")

func _process(delta):
	if win_timer > 0:
		win_timer -= delta
		var db = AudioServer.get_bus_volume_db(audio_bus) - 10 * delta
		db = clamp(db, -80, 0)
		AudioServer.set_bus_volume_db(audio_bus, db)
		if win_timer <= 0:
			get_node("../Transition").transition_to(WinScreen, get_parent())
			queue_free()
		return
	
	wave_time += delta
	
	# This is just to make sure there's no wraparound...
	# really shouldn't matter in practice
	if wave_time > 10000:
		wave_time = 10000
		
	if Global.enemy_count == 0:
		next_wave()
	
	if wave == null:
		return
	
	var erase_list = []
	for w in wave:
		if w[1] <= wave_time:
			erase_list.append(w)
			spawn(w)
			
	for w in erase_list:
		wave.erase(w)
		
# LEVEL WAVE DEFINITIONS

var tutorial_waves = [[scroll1(0.2, Vector2(200, 900)), scroll1(0.3, Vector2(600, 900))]]
			
var level1 = [
	[scroll1(2, Vector2(384, 700))],
	[scroll1(1, Vector2(200, 700)), scroll1(1.5, Vector2(568, 700)), scroll1(1.8, Vector2(384, 750))],
	[scroll2(1.3, Vector2(384, 800))],
	[scroll1(1, Vector2(200, 800)), scroll1(1.5, Vector2(250, 800)), scroll1(1.5, Vector2(518, 800)), scroll1(1, Vector2(568, 800)), scroll2(2.5, Vector2(384, 750))]
]

var level2 = [
	[cauldron(2, Vector2(384, 700))],
	[cauldron(1, Vector2(294, 750)), cauldron(1.2, Vector2(384, 750)), cauldron(1.4, Vector2(474, 750))],
	[cauldron(1, Vector2(200, 750)), scroll1(1.2, Vector2(500, 740)), scroll1(1.3, Vector2(580, 740)),scroll1(4.5, Vector2(500, 800)), scroll2(5, Vector2(580, 800))
	]
]

var level3 = [
	[book(2, Vector2(384, 700)), book(2, Vector2(192, 750)), book(2, Vector2(576, 750))],
	[book(1.5, Vector2(384, 700)), scroll2(1.3, Vector2(200, 750)), scroll1(1.35, Vector2(568, 745))],
	[book(1.5, Vector2(330, 750)), cauldron(1.3, Vector2(384, 700)), book(1.5, Vector2(400, 750))],
	[scroll2(1, Vector2(200, 750)), scroll2(1.1, Vector2(250, 700)),
	cauldron(1.15, Vector2(584, 700)), book(1.3, Vector2(584, 750)), book(1.3, Vector2(500, 800)), book(1.35, Vector2(600, 800))]
]

var level4 = [
	[crystal(2, Vector2(200, 700))]
]
