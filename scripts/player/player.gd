extends KinematicBody2D

export(float, 0, 1.0) var friction = 0.2
export(float, 0, 1.0) var acceleration = 0.25

var SLOPE_STOP = 2 * Globals.TILE_SIZE

var move_speed = 5 * Globals.TILE_SIZE
var min_jump_height = 0.8 * Globals.TILE_SIZE
var max_jump_height = 4 * Globals.TILE_SIZE
var min_jump_speed
var max_jump_speed
var gravity
var is_grounded

onready var _velocity = Vector2(0, 0)
onready var is_jumping = false
onready var jump_duration = 0.5
#onready var groundRaycasts = $GroundRayCasts

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	min_jump_speed = sqrt(2 * gravity * min_jump_height)
	max_jump_speed = sqrt(2 * gravity * max_jump_height)

func _process(delta):
	if(Input.is_action_just_pressed("dbp_escape")):
		get_tree().quit()

func _physics_process(delta):
	_process_physic_input(delta)

	_velocity = move_and_slide(_velocity, Vector2.UP, SLOPE_STOP)
	
	#is_grounded = _check_is_grounded()

func _process_physic_input(delta):
	var move_dir = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")

	if move_dir != 0:
		_velocity.x = lerp(_velocity.x, move_dir * move_speed, acceleration)
	else:
		_velocity.x = lerp(_velocity.x, 0, friction)

	_velocity.y += gravity * delta

	if is_jumping && _velocity.x >= 0:
		is_jumping = false

	if (Input.is_action_just_pressed("player_jump") && is_on_floor()):
		_velocity.y -= max_jump_speed

	if (Input.is_action_just_released("player_jump") && _velocity.y <= -min_jump_speed):
		_velocity.y = -min_jump_speed

#_check_is_grounded
