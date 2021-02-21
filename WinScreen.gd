extends Node2D

var Game = preload("res://Game.tscn")
var Menu = preload("res://Menu.tscn")

var next_level

func _ready():
	next_level = Global.level + 1
	if next_level > 4:
		next_level = 4
	if next_level < 0:
		next_level = 0
	pass
	#Music.set_menu_playing(true)

func _level_sel():
	Global.level = next_level
	
	#Music.set_menu_playing(false)
	$Transition.transition_to(Game, self)
	
func _menu_sel():
	$Transition.transition_to(Menu, self)
