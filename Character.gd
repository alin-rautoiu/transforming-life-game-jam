extends KinematicBody2D

var GRAVITY = 800.0
export var MAX_WALK_SPEED: float = 400
export var JUMP_HEIGHT: float = 500
export var ACCELERATION: float = 20
export var JUMP_ACCELERATION: float = 800

export var FALL_MULTIPLIER: float = 5.5
export var LOW_JUMP_MULTIPLIER: float = 2.0

var velocity = Vector2()
var last_velocity = Vector2()
var was_on_floor = true
var camera_limits = Vector2(3000, 365)
var block_inputs = false
const UP = Vector2(0, -1)

func _ready():
	$Camera2D.limit_left = 365
	$Camera2D.limit_right = 3000

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	var friction = false
	#print($CharacterSprite.animation)
	if Input.is_action_pressed("ui_left") and !block_inputs:
		velocity.x = clamp(velocity.x - ACCELERATION, -MAX_WALK_SPEED, 0)
		$CharacterSprite.flip_h = true;
		if is_on_floor():
			$CharacterSprite.play("walk")
	elif Input.is_action_pressed("ui_right") and !block_inputs:
		velocity.x = clamp(velocity.x + ACCELERATION, 0, MAX_WALK_SPEED)
		$CharacterSprite.flip_h = false;
		if is_on_floor():
			$CharacterSprite.play("walk")
	else:
		friction = true
		if velocity.y - last_velocity.y <= 0.0001 and is_not_landing():
			$CharacterSprite.play("idle")

	
	if is_on_floor():
		if !was_on_floor:
			$CharacterSprite.play("land")
			print("land")
			was_on_floor = true
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.2)
		if Input.is_action_pressed("ui_jump") and !block_inputs:
			was_on_floor = false;
			if !$JumpAudio.playing:
				$JumpAudio.play()
				$CharacterSprite.play("jump")
			velocity.y -= JUMP_ACCELERATION
	else:
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.05)
	#print(last_velocity.y - velocity.y)
	
	if velocity.y > 0:
		velocity.y += delta * GRAVITY * FALL_MULTIPLIER - 1
	
	if velocity.y < 0:	
		if !Input.is_action_pressed("ui_jump"):
			velocity.y += delta * GRAVITY * LOW_JUMP_MULTIPLIER - 1
	
	last_velocity = velocity
	if get_slide_collision(get_slide_count() - 1):		
		var angle = UP.angle_to(get_slide_collision(get_slide_count() - 1).normal)
		if (abs(UP.angle_to(get_slide_collision(get_slide_count() - 1).normal)) < 0.45):
			rotation = lerp(rotation, UP.angle_to(get_slide_collision(get_slide_count() - 1).normal), 0.5)
		else:
		 rotation = lerp(rotation, 0, 0.5)
	velocity = move_and_slide(velocity, UP)

func move_to(spawn_position, limits):
	global_position = spawn_position
	camera_limits = limits
	shift_camera_limits(limits.y, limits.x)

func remove_camera_limits():	
	shift_camera_limits(-10000000, 10000000)

func reset_camera_limits():	
	shift_camera_limits(camera_limits.y, camera_limits.x)
	
func shift_camera_limits(left, right):
	block_inputs = true
	for i in range(0,33):
		yield(get_tree().create_timer(0.03), "timeout")
		$Camera2D.limit_left = lerp($Camera2D.limit_left, left, 0.03)
		$Camera2D.limit_right = lerp($Camera2D.limit_right, right, 0.03)
#	
	print(block_inputs)
	block_inputs = false
	
func is_not_landing():
	print()
	return $CharacterSprite.animation != "land" or ($CharacterSprite.animation == "land" and $CharacterSprite.frame == 7)