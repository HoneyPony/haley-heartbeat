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
	
func broom(time, position):
	return [5, time, position]
	
func hpit(time):
	return [6, time]
	
func lpit(time):
	return [7, time]

func rpit(time):
	return [8, time]
	
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
var Broom = preload("res://BroomEnemy.tscn")
var HPit = preload("res://HorizontalPit.tscn")
var LPit = preload("res://PitLeft.tscn")
var RPit = preload("res://PitRight.tscn")

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
	
func spawn_broom(position):
	var s = Broom.instance()
	s.position.x = position.x
	s.position.y = 1060
	s.spawn_y = position.y
	ysort.add_child(s)
	
func spawn_hpit():
	var h = HPit.instance()
	get_parent().add_child(h)
	
func spawn_lpit():
	var h = LPit.instance()
	get_parent().add_child(h)
	
func spawn_rpit():
	var h = RPit.instance()
	get_parent().add_child(h)
	
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
	if what[0] == 5:
		spawn_broom(what[2])
	if what[0] == 6:
		spawn_hpit()
	if what[0] == 7:
		spawn_lpit()
	if what[0] == 8:
		spawn_rpit()
		
func _ready():
	if Global.level == 1:
		waveset = level1
		get_node("../Layer/Intro/AnimationPlayer").play("Level1")
	if Global.level == 2:
		waveset = level2
	if Global.level == 3:
		waveset = level3
	if Global.level == 4:
		waveset = level4
	if Global.level == 5:
		waveset = level5
		
	next_wave()
		
func send_wave(a_wave):
	wave = a_wave
	wave_time = 0
	
	Global.enemy_count = wave.size()
	
var House = preload("res://House.tscn")
	
func next_wave():
	# Special win condition for tutorial level
	if Global.level == 0 and wave != null:
		win_timer = 3
		return
	
	if waveset == null:
		return
	
	wave_index += 1
	if wave_index < waveset.size():
		send_wave(waveset[wave_index])
		
	else:
		win_timer = 3
		if Global.level == Global.LAST_LEVEL:
			var h = House.instance()
			ysort.add_child(h)

onready var WinScreen = load("res://WinScreen.tscn")
onready var LastWinScreen = load("res://LastWinScreen.tscn")
onready var audio_bus = AudioServer.get_bus_index("GameMusic")

func _process(delta):
	if win_timer > 0:
		win_timer -= delta
		var db = AudioServer.get_bus_volume_db(audio_bus) - 10 * delta
		db = clamp(db, -80, 0)
		AudioServer.set_bus_volume_db(audio_bus, db)
		if win_timer <= 0:
			if Global.level == Global.LAST_LEVEL:
				get_node("../Transition").transition_to(LastWinScreen, get_parent())
			else:
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
	[scroll1(7, Vector2(384, 700))],
	[hpit(0)],
	[scroll1(1, Vector2(200, 700)), scroll1(1.5, Vector2(568, 700)), scroll1(1.8, Vector2(384, 750))],
	[scroll2(1.3, Vector2(384, 800))],
	[hpit(0), hpit(2), lpit(4)],
	[scroll1(1, Vector2(200, 800)), scroll1(1.5, Vector2(250, 800)), scroll1(1.5, Vector2(518, 800)), scroll1(1, Vector2(568, 800)), scroll2(2.5, Vector2(384, 750))]
]

var level2 = [
	[hpit(2), lpit(4)],
	[cauldron(2, Vector2(384, 700))],
	[cauldron(1, Vector2(294, 750)), cauldron(1.2, Vector2(384, 750)), cauldron(1.4, Vector2(474, 750))],
	[lpit(0), rpit(2), lpit(4)],
	[cauldron(1, Vector2(200, 750)), scroll1(1.2, Vector2(500, 740)), scroll1(1.3, Vector2(580, 740)),scroll1(4.5, Vector2(500, 800)), scroll2(5, Vector2(580, 800))
	]
]

var level3 = [
	[hpit(1), lpit(3)],
	[book(2, Vector2(384, 700)), book(2, Vector2(192, 750)), book(2, Vector2(576, 750))],
	[book(1.5, Vector2(384, 700)), scroll2(1.3, Vector2(200, 750)), scroll1(1.35, Vector2(568, 745))],
	[rpit(0), lpit(2), hpit(4)],
	[book(1.5, Vector2(330, 750)), cauldron(1.3, Vector2(384, 700)), book(1.5, Vector2(400, 750))],
	[hpit(0)],
	[scroll2(1, Vector2(200, 750)), scroll2(1.1, Vector2(250, 700)),
	cauldron(1.15, Vector2(584, 700)), book(1.3, Vector2(584, 750)), book(1.3, Vector2(500, 800)), book(1.35, Vector2(600, 800))]
]

var level4 = [
	[crystal(2, Vector2(200, 600))],
	[rpit(0), lpit(2), rpit(5)],
	[crystal(1, Vector2(530, 630)), scroll2(1.2, Vector2(200, 800)), scroll2(1.4, Vector2(250, 850))],
	[lpit(2)],
	[crystal(1, Vector2(200, 650)), crystal(1.2, Vector2(568, 700)), book(1.4, Vector2(230, 690)), scroll2(1.5, Vector2(600, 750))],
	[hpit(0), hpit(2)],
	[cauldron(1, Vector2(384, 650)), crystal(0.7, Vector2(384, 700)), scroll2(1, Vector2(200, 800)), scroll2(1, Vector2(584, 800))]
]

var level5 = [
	[broom(2, Vector2(384, 650))],
	[lpit(0)],
	[broom(1, Vector2(384, 650)), crystal(1, Vector2(200, 600)), book(1.4, Vector2(200, 650)), book(1.8, Vector2(150, 700))],
	[rpit(0), hpit(2)],
	[broom(1, Vector2(150, 650)), cauldron(3, Vector2(584, 600)), scroll1(2, Vector2(180, 800)), scroll2(2.2, Vector2(260, 850)), book(2.3, Vector2(584, 650))],
	[hpit(0), lpit(2), rpit(4), lpit(6), hpit(8)],
	[broom(3, Vector2(384, 650)), cauldron(1, Vector2(200, 700)), cauldron(1, Vector2(584, 550)), book(2, Vector2(200, 750)), crystal(2, Vector2(584, 600)), scroll2(0.7, Vector2(400, 600))]
]
