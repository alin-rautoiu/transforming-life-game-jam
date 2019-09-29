extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Character":
		body.hit_enemy()
		if body.has_tepi:
			queue_free()
