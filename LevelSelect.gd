extends Node2D

var Game = preload("res://Game.tscn")

onready var Menu = load("res://Menu.tscn")

func _ready():
	Music.set_menu_playing(true)
	$FocusGrab.grab_focus()

func level_sel(button: Button):
	var num = button.text.substr(5)
	var as_int = int(num)
	
	Global.level = as_int
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	
	Music.set_menu_playing(false)
	$Transition.transition_to(Game, self)

func _menu_sel():
	$Transition.transition_to(Menu, self)
