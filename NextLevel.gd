extends Area2D

export(NodePath) var spawn_point_path = NodePath()
export(Vector2) var limits = Vector2()
onready var spawn_point: Position2D = get_node(spawn_point_path)

func _ready():
	print(spawn_point)
	connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	if body.name == "Character":
		body.move_to(spawn_point.global_position, limits)
