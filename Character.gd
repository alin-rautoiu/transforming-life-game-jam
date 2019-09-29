extends KinematicBody2D

var GRAVITY = 800.0
export var MAX_WALK_SPEED: float = 400
export var JUMP_HEIGHT: float = 600
export var ACCELERATION: float = 30
export var JUMP_ACCELERATION: float = 1000

export var FALL_MULTIPLIER: float = 5.5
export var LOW_JUMP_MULTIPLIER: float = 2.0

export var has_tepi = false
var is_tepos = false

export var has_swimp = false
var is_swim = false

var velocity = Vector2()
var last_velocity = Vector2()
var was_on_floor = true
var camera_limits = Vector2(3000, 365)
var last_spawn_point: Vector2 = Vector2(1030.991, -182.144)
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
		$"CharacterSprite/virus tep fara picioare".flip_h = true
		if is_on_floor():
			if is_swim:
				$CharacterSprite.play("wobble_walk")	
			else:
				$CharacterSprite.play("walk")
	elif Input.is_action_pressed("ui_right") and !block_inputs:
		velocity.x = clamp(velocity.x + ACCELERATION, 0, MAX_WALK_SPEED)
		$CharacterSprite.flip_h = false;
		$"CharacterSprite/virus tep fara picioare".flip_h = false
		if is_on_floor():
			if is_swim:
				$CharacterSprite.play("wobble_walk")	
			else:
				$CharacterSprite.play("walk")
	else:
		friction = true
		if velocity.y - last_velocity.y <= 0.0001 and is_not_landing():
			if is_swim:
				$CharacterSprite.play("wobble_idle")	
			else:
				$CharacterSprite.play("idle")
	
	if is_on_floor():
		if !was_on_floor:
			if !is_swim:
				$CharacterSprite.play("land")
			was_on_floor = true
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.2)
		if Input.is_action_pressed("ui_jump") and !block_inputs:
			was_on_floor = false;
			if !$JumpAudio.playing:
				$JumpAudio.play()
				if !is_swim:
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
	if get_slide_count() > 0 and get_slide_collision(get_slide_count() - 1):		
		var angle = UP.angle_to(get_slide_collision(get_slide_count() - 1).normal)
		if (abs(UP.angle_to(get_slide_collision(get_slide_count() - 1).normal)) < 0.45):
			rotation = lerp(rotation, UP.angle_to(get_slide_collision(get_slide_count() - 1).normal), 0.5)
		else:
		 rotation = lerp(rotation, 0, 0.5)
	velocity = move_and_slide(velocity, UP)
	
	if has_tepi and Input.is_action_just_pressed("ui_spikes"):
		is_tepos = !is_tepos
		is_swim = false
		$CharacterSprite.play("idle")
		$"CharacterSprite/virus tep fara picioare".visible = !$"CharacterSprite/virus tep fara picioare".visible 
		
	if has_swimp and Input.is_action_just_pressed("ui_swimp"):
		is_swim = !is_swim
		$"CharacterSprite/virus tep fara picioare".visible = false
		$CharacterSprite.play("wobble_idle")	
		is_tepos = false
		

func move_to(spawn_position, limits):
	global_position = spawn_position
	last_spawn_point = spawn_position
	camera_limits = limits
	block_inputs = true
	shift_camera_limits(limits.y, limits.x)

func remove_camera_limits():	
	block_inputs = true
	shift_camera_limits(-10000000, 10000000)

func reset_camera_limits():	
	shift_camera_limits(camera_limits.y, camera_limits.x)
	
func shift_camera_limits(left, right):
	for i in range(0,34):
		yield(get_tree().create_timer(0.02), "timeout")
		$Camera2D.limit_left = lerp($Camera2D.limit_left, left, 0.11)
		$Camera2D.limit_right = lerp($Camera2D.limit_right, right, 0.11)
	
	$Camera2D.limit_left = left
	$Camera2D.limit_right = right
	print(block_inputs)
	block_inputs = false

func collect_spikes():
	has_tepi = true
	is_tepos = true
	$"CharacterSprite/virus tep fara picioare".visible = true
	
func collect_swim():
	has_swimp = true
	is_swim = true

func hit_enemy():
	if !has_tepi:
		global_position = last_spawn_point
		$AnimationPlayer.play_backwards("Dissolve")

func enter_water():
	if !is_swim:
		$AnimationPlayer.play("Dissolve")
		yield(get_tree().create_timer(0.5), "timeout")
		global_position = last_spawn_point
		$AnimationPlayer.play_backwards("Dissolve")
	else:
		return

func exit_water():
	return

func is_not_landing():
	print()
	return $CharacterSprite.animation != "land" or ($CharacterSprite.animation == "land" and $CharacterSprite.frame == 7)