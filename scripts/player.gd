extends KinematicBody2D

export(float) var speed = 64
export(float) var jump_height = 128
export(float) var air_control_mult = 1


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("player_move_left")):
		print("left")
	if(Input.is_action_pressed("player_move_right")):
		print("right")
	if(Input.is_action_just_pressed("player_jump")):
		print("jump")

#func _input(event):
#	if(Input.is_action_pressed("player_move_left")):
#		print("left")
#	if(Input.is_action_pressed("player_move_right")):
#		print("right")
#	if(Input.is_action_just_pressed("player_jump")):
#		print("jump")