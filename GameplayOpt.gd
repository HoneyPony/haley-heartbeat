extends "res://TextHover.gd"

export var key = "speed"
export (NodePath) var label

func slide_to_val(s):
	var expo = ((s - 50) / 50) * 2
	return pow(2, expo)
	
func val_to_slide(v):
	var l = log(v) / log(2)
	return ((l / 2) * 50) + 50
	
func _ready():
	label = get_node(label)
	self.value = val_to_slide(Global.game_opts[key])
	
func _process(delta):
	var val = slide_to_val(self.value)
	Global.game_opts[key] = val
	
	var per = val * 100
	per = int(per)
	label.text = String(per) + "%"
