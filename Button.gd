extends KinematicBody2D

var is_pressed: bool = false
export var which = 1

func _ready() -> void:	
	$Area2D2.connect("body_entered", self, "on_button_press")
	$Area2D2.connect("body_exited", self, "on_button_release")
	
func on_button_press(body) -> void:
	if body.name != "Character":
		return
		
	if body.name == "Character" and !is_pressed:
		$AnimationPlayer.play("Pressed")
		yield(get_tree().create_timer(0.42), "timeout")
		if which != 3:
			$AnimationPlayer2.play("zoom1")
		else:
			print(which)
			$AnimationPlayer2.play("zoom2")
		is_pressed = true
		body.remove_camera_limits()
		
	if which == 1:
		get_node("../manuta/AnimationPlayer").play("Move")
	if which == 2:
		get_node("../platforme tepi/AnimationPlayer").play("GetSpikes")
	if which == 3:
		get_node("../Node2D/fundal monstru 3/AnimationPlayer").play("Hapciu")

func on_button_release(body) -> void:
	if body.name == "Character" and is_pressed:
		$AnimationPlayer.play_backwards("Pressed")
		is_pressed = false
		body.reset_camera_limits()