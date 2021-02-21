extends Node2D

onready var bus = AudioServer.get_bus_index("Master")

func _ready():
	AudioServer.set_bus_mute(bus, true)
	queue_free()

func _exit_tree():
	AudioServer.set_bus_mute(bus, false)
