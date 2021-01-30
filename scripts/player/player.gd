extends KinematicBody2D

export(float, 0, 1.0) var friction = 0.2
export(float, 0, 1.0) var acceleration = 0.2
export(float, 0, 1.0) var anim_move_threshold = 30

var SLOPE_STOP = 2 * Globals.TILE_SIZE
var SLOPE_JUMP_SPEED_THRESHOLD = 1.5 * Globals.TILE_SIZE

var move_speed = 5 * Globals.TILE_SIZE
var min_jump_height = 0.75 * Globals.TILE_SIZE
var max_jump_height = 4 * Globals.TILE_SIZE
var min_jump_speed
var max_jump_speed
var gravity
var is_grounded : bool

onready var _velocity = Vector2(0, 0)
onready var is_jumping = false
onready var jump_duration = 0.5
onready var groundRaycasts = $GroundRayCasts
onready var _anim_tree = $AnimationTree
onready var _anim_sprite = $Sprite
onready var _anim_state = _anim_tree.get("parameters/playback")

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	min_jump_speed = sqrt(2 * gravity * min_jump_height)
	max_jump_speed = sqrt(2 * gravity * max_jump_height)


func _process(delta):
	if(Input.is_action_just_pressed("dbp_escape")):
		get_tree().quit()
	update_anim_state()
	
	
func _physics_process(delta):
	_process_physic_input(delta)
	_velocity = move_and_slide(_velocity, Vector2.UP, SLOPE_STOP)
	
	is_grounded = _check_is_grounded()

func _process_physic_input(delta):
	var move_dir = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")

	if move_dir != 0:
		_velocity.x = lerp(_velocity.x, move_dir * move_speed, acceleration)
	else:
		_velocity.x = lerp(_velocity.x, 0, friction)

	_velocity.y += gravity * delta

	if (Input.is_action_just_pressed("player_jump") && is_grounded):
		_velocity.y -= max_jump_speed
		is_jumping = true

	if (Input.is_action_just_released("player_jump") && _velocity.y <= -min_jump_speed):
		_velocity.y = -min_jump_speed
		is_jumping = true


func _check_is_grounded():
	for raycast in groundRaycasts.get_children():
		if raycast.is_colliding():
			return true
	# Not colliding
	return false
	
	
func update_anim_state():
	var is_moving = _velocity.length_squared() >= anim_move_threshold * anim_move_threshold
	_anim_tree["parameters/conditions/IsMoving"] = is_moving and is_grounded
	_anim_tree["parameters/conditions/IsNotMoving"] = not is_moving
#
	if _anim_sprite.flip_h and _velocity.x > 0 or _velocity.x < 0:
		_anim_sprite.flip_h = _velocity.x < 0
	if is_jumping && _velocity.y > 0:
		is_jumping = false

	_anim_tree["parameters/conditions/IsJumping"] = is_jumping
	_anim_tree["parameters/conditions/IsFalling"] = not is_grounded and not is_jumping
	_anim_tree["parameters/conditions/IsNotFalling"] = is_grounded and not is_jumping
