extends "res://TextHover.gd"

export var bus_name = "Master"

onready var bus = AudioServer.get_bus_index(bus_name)

func slide_to_vol(s):
	if s >= 50:
		return ((s - 50) / 50) * 10
	return ((s - 50) / 50) * 60
	
func vol_to_slide(v):
	if v >= 0:
		return ((v) / 10) * 50 + 50
	return ((v + 60) / 60) * 50
	
func _ready():
	self.value = vol_to_slide(AudioServer.get_bus_volume_db(bus))
	
func _process(delta):
	AudioServer.set_bus_volume_db(bus, slide_to_vol(self.value))
