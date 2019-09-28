extends Area2D

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.name == "Character":
		body.enter_water()
		
func on_body_exited(body):
	if body.name == "Character":
		body.exit_water()		