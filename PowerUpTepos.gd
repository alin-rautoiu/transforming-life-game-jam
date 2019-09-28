extends Node2D

func ready() -> void:
#	$"powerup tepos/Area2D".connect("body_entered", self, "on_body_entered")
	return
	
func _on_Area2D_body_entered(body):
	print("hit")
	if body.name == "Character":
		body.collect_spikes()
	queue_free()
