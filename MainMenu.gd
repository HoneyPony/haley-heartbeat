extends Node2D

func _ready():
	Music.set_menu_playing(true)

var LevelSelect = preload("res://LevelSelect.tscn")

func _on_button():
	$Transition.transition_to(LevelSelect, self)
