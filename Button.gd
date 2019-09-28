extends KinematicBody2D

var is_pressed: bool = false

func _ready() -> void:	
	$Area2D2.connect("body_entered", self, "on_button_press")
	$Area2D2.connect("body_exited", self, "on_button_release")
	
func on_button_press(body) -> void:
	if body.name == "Character" and !is_pressed:
		$AnimationPlayer.play("Pressed")
		$AnimationPlayer2.play("zoom1")
		is_pressed = true
		body.remove_camera_limits()

func on_button_release(body) -> void:
	if body.name == "Character" and is_pressed:
		$AnimationPlayer.play_backwards("Pressed")
		is_pressed = false
		body.reset_camera_limits()