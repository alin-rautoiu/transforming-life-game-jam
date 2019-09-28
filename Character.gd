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

const UP = Vector2(0, -1)

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	var friction = false
	#print($CharacterSprite.animation)
	if Input.is_action_pressed("ui_left"):
		velocity.x = clamp(velocity.x - ACCELERATION, -MAX_WALK_SPEED, 0)
		$CharacterSprite.flip_h = true;
		if is_on_floor():
			$CharacterSprite.play("walk")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = clamp(velocity.x + ACCELERATION, 0, MAX_WALK_SPEED)
		$CharacterSprite.flip_h = false;
		if is_on_floor():
			$CharacterSprite.play("walk")
	else:
		friction = true
		if velocity.y - last_velocity.y <= 0.0001 and is_not_landing():
			$CharacterSprite.play("idle")

	if is_on_floor():
		if !was_on_floor and is_on_wall():
			$CharacterSprite.play("land")
			was_on_floor = true
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.2)
		if Input.is_action_pressed("ui_jump"):
			if !$JumpAudio.playing:
				$JumpAudio.play()
			if velocity.y < 0:
				$CharacterSprite.play("jump")
			velocity.y -= JUMP_ACCELERATION
	else: 
		was_on_floor = false;
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.05)
	print(last_velocity.y - velocity.y)
	if !is_on_floor():
		velocity.y += delta * GRAVITY * FALL_MULTIPLIER - 1
		
		if !Input.is_action_pressed("ui_jump"):
			velocity.y += delta * GRAVITY * LOW_JUMP_MULTIPLIER - 1
	
    # We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

    # The second parameter of "move_and_slide" is the normal pointing up.
    # In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	last_velocity = velocity
	
	velocity = move_and_slide(velocity, UP)
	
func is_not_landing():
	print($CharacterSprite.frames.get_frame_count("land"))
	return $CharacterSprite.animation != "land" or ($CharacterSprite.animation == "land" and $CharacterSprite.frames.get_frame_count("land") == 8)