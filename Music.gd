extends Node

onready var menu_idx = AudioServer.get_bus_index("MenuMusic")

func set_menu_playing(what):
	AudioServer.set_bus_mute(menu_idx, !what)

func _ready():
	$Menu.play()
