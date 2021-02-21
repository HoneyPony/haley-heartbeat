extends Node

onready var menu_idx = AudioServer.get_bus_index("MenuMusic")

var menu_playing = false

func set_menu_playing(what):
	if not menu_playing and what:
		$Menu.play()
	if menu_playing and not what:
		$Menu.stop()
		
	menu_playing = what
	AudioServer.set_bus_mute(menu_idx, !what)

func _ready():
	set_menu_playing(true)
