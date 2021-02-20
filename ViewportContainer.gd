extends ViewportContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.root_for_scenes = get_node("Viewport")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var height = get_viewport().size.y
	var width = get_viewport().size.x
	
	var my_height = height
	var my_width = my_height * (768.0 / 960)
	
	var scale = my_height / 960.0
	
	rect_scale = Vector2(scale, scale)
	rect_position.x = (width - my_width) / 2
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
