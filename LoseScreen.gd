extends Node2D

var Game = preload("res://Game.tscn")
var Menu = preload("res://Menu.tscn")

var next_level

func _ready():
	next_level = Global.level
	pass
	#Music.set_menu_playing(true)

func _level_sel():
	Global.level = next_level
	$Transition.transition_to(Game, self)
	
func _menu_sel():
	$Transition.transition_to(Menu, self)
