extends Control

onready var Menu = load("res://Menu.tscn")

var next_level

func show_up():
	show()
	$FocusGrab.show()
	$FocusGrab.grab_focus()
	
	paused = true
	get_tree().paused = true

	
func go_away():
	$FocusGrab.grab_focus()
	$FocusGrab.hide()
	hide()
	
	paused = false
	get_tree().paused = false

func _ready():
	# Tell the root viewport to process. This is necessary because Godot is weird
	get_node("/root").pause_mode = PAUSE_MODE_PROCESS
	go_away()
	
func _resume_sel():
	go_away()
	
func _menu_sel():
	go_away()
	get_node("../../Transition").transition_to(Menu, get_node("../../"))

var paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if paused:
			go_away()
		else:
			show_up()
