extends Node2D

var Game = preload("res://Game.tscn")

func _ready():
	Music.set_menu_playing(true)

func level_sel(button: Button):
	var num = button.text.substr(5)
	var as_int = int(num)
	
	Global.level = as_int
	
	Music.set_menu_playing(false)
	$Transition.transition_to(Game, self)
