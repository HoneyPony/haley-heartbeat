extends CanvasLayer

var timer = -1
var next_scene = null
var last_scene = null

func transition_to(scene, scene_from):
	next_scene = scene
	last_scene = scene_from
	timer = 15.0 / 24.0
	$Out.show()
	$Out.play()
	
func _ready():
	$In.show()
	$In.play()
	
func switch_scene_to(scene):
	var node = next_scene.instance()
	last_scene.queue_free()
	Global.root_for_scenes.add_child(node)
	
	
func _process(delta):
	if next_scene != null:
		timer -= delta
		if timer <= 0:
			switch_scene_to(next_scene)
