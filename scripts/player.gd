extends KinematicBody2D

export(float) var move_speed = 64
export(float) var jump_height = -256
export(float) var air_control_mult = 0.25
export (int) var gravity = 256

var _velocity = Vector2(0, 0)
var _jumping = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("dbp_escape")):
		get_tree().quit()

func get_physic_input():
	var move_speed_mult = 1;

	if (is_on_floor()):
		_velocity = Vector2.ZERO
	else:
		move_speed_mult = air_control_mult

	if(Input.is_action_pressed("player_move_left")):
		_velocity.x -= move_speed * move_speed_mult
	if(Input.is_action_pressed("player_move_right")):
		_velocity.x += move_speed * move_speed_mult
	if(Input.is_action_just_pressed("player_jump")):
		_velocity.y += jump_height
		_jumping = true

func _physics_process(delta):
	get_physic_input()

	if (_jumping):
		_jumping = false

	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

#func _input(event):
#	if(Input.is_action_pressed("player_move_left")):
#		print("left")
#	if(Input.is_action_pressed("player_move_right")):
#		print("right")
#	if(Input.is_action_just_pressed("player_jump")):
#		print("jump")
