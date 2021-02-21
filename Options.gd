extends Node2D

func _ready():
	Music.set_menu_playing(true)
	$FocusGrab.grab_focus()

onready var Menu = load("res://Menu.tscn")

func _on_button():
	$Transition.transition_to(Menu, self)
