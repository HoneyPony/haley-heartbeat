extends Node2D

func _on_hit(body):
	body.hit_something()
	
	$Flash/Anim.play("Flash")
