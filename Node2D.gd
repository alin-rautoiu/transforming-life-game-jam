extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var screen_dimensions = get_viewport().size

onready var green_triangle = load("res://GreenTriangle.tscn")
onready var red_triangle = load("res://RedTriangle.tscn")

onready var objects = [green_triangle, red_triangle]
onready var ray : RayCast2D = $RayCast2D

var instances = []
var rng = RandomNumberGenerator.new()

func _unhandled_input(event) -> void:	
	if event is InputEventMouseButton and event.is_pressed():
		var instance = objects[int(rng.randf() * objects.size())].instance()
		instance.name = "instance" + str(instances.size())
		instances.append(instance)
		
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(ray.position, instance.position,
                    [self], 0)
		print(result)
		instance.global_position = Vector2(rng.randf() * screen_dimensions.x, rng.randf() * screen_dimensions.y)
		ray.cast_to = instance.global_position		
		draw_line(ray.global_position, ray.cast_to, Color.red, 100.0)
		add_child(instance)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
