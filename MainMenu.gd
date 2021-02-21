extends Node2D

func _ready():
	Music.set_menu_playing(true)
	$FocusGrab.grab_focus()

var LevelSelect = preload("res://LevelSelect.tscn")
var Opt = preload("res://Options.tscn")

func _on_button():
	$Transition.transition_to(LevelSelect, self)


func _on_opt():
	$Transition.transition_to(Opt, self)
