extends Node2D

export(PackedScene) var player_class
export(NodePath) var player_start_ref

onready var player_start_pos = get_node(player_start_ref).position
var player = null

func _ready():
	initialize()
	
func initialize():
	player = player_class.instance()
	player.position = player_start_pos
	add_child(player)

func reset():
	player.position = player_start_pos
