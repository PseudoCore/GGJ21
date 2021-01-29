extends KinematicBody2D

export(float, 0, 1.0) var friction = 0.2
export(float, 0, 1.0) var acceleration = 0.25

var move_speed = 5 * Globals.UNIT_SIZE
var min_jump_height = 1 * Globals.UNIT_SIZE
var max_jump_height = 4 * Globals.UNIT_SIZE
var min_jump_speed
var max_jump_speed
var gravity

onready var _velocity = Vector2(0, 0)
onready var is_jumping = false
onready var jump_duration = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	min_jump_speed = sqrt(2 * gravity * min_jump_height)
	max_jump_speed = sqrt(2 * gravity * max_jump_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("dbp_escape")):
		get_tree().quit()

func _physics_process(delta):
	_process_physic_input(delta)

	_velocity = move_and_slide(_velocity, Vector2.UP)

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
