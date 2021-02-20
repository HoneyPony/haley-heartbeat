extends CanvasLayer

var enabled = true

onready var heart_ui = get_node("../Layer")

enum Cond {
	Move,
	JumpPit,
	Shoot,
	ShowHealth
	None
}

onready var labels = [$Label1, $Label2, $Label3, $Label4, $Label5, $Label6, $Label7, $Label8]
onready var conditions = [Cond.Move, Cond.JumpPit, Cond.Shoot, Cond.ShowHealth, Cond.None, Cond.None, Cond.None, Cond.None]
var label_index = 0

var f_cond_move = false
var f_cond_jump_pit = false
var f_cond_shoot = false

# How long a label should be shown before the next label is shown
var allow_transition_timer = 0
const TRANSITION_TIME = 3.2

# Timer used to animate labels
var fade_timer = 0

const FADE_TIME = 1.5

enum State {
	Wait,
	FadeIn,
	FadeOut
}

var state = State.Wait

func _ready():
	enabled = Global.level == 0
	
	Global.tutorial = self
	
	if not enabled:
		set_process(false)
		return
	
	# Hide the heart ui
	heart_ui.transform.origin = Vector2(0, -1000)
	labels[0].show()
	allow_transition_timer = TRANSITION_TIME
	
func start_fade_out():
	state = State.FadeOut
	
	fade_timer = FADE_TIME
	
func start_fade_in():
	state = State.FadeIn
	
	labels[label_index].hide()
	label_index += 1
	if label_index >= labels.size():
		enabled = false
		set_process(false)
		
		var spawn = get_node("../Spawner")
		spawn.send_wave(spawn.tutorial_waves[0])
		return
	labels[label_index].show()
	labels[label_index].modulate.a = 0
	
	fade_timer = FADE_TIME
	
	if conditions[label_index] == Cond.ShowHealth:
		heart_ui.transform.origin = Vector2.ZERO
		get_node("../YSort/Player").restore_health()
	
var TutPit = preload("res://HorizontalPitTut.tscn")
	
func start_wait():
	state = State.Wait
	labels[label_index].modulate.a = 1
	allow_transition_timer = TRANSITION_TIME
	
	if conditions[label_index] == Cond.JumpPit:
		var pit = TutPit.instance()
		pit.position = Vector2(0, 1200)
		get_parent().add_child(pit)
	
	
func cond_fulfilled():
	var c = conditions[label_index]
	if c == Cond.None:
		return true
	if c == Cond.Move:
		return f_cond_move
	if c == Cond.JumpPit:
		return f_cond_jump_pit
	if c == Cond.Shoot:
		return f_cond_shoot
	return true
	
func _process(delta):	
	if state == State.Wait:
		allow_transition_timer -= delta
		if allow_transition_timer <= 0 and cond_fulfilled():
			start_fade_out()
	elif state == State.FadeOut:
		fade_timer -= delta
		labels[label_index].modulate.a = fade_timer / FADE_TIME
		if fade_timer <= 0:
			start_fade_in()
	elif state == State.FadeIn:
		fade_timer -= delta
		labels[label_index].modulate.a = (1.0 - (fade_timer / FADE_TIME))
		if fade_timer <= 0:
			start_wait()
