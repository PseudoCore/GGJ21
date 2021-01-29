extends Node2D

export(NodePath) var player_start_ref
onready var player_start_pos = get_node(player_start_ref).position
var player = null

func _ready():
	initialize()
	
func initialize():
	player = Game.player_class.instance()
	player.position = player_start_pos
	add_child(player)

func reset_level():
	if player:
		player.queue_free()
	initialize()
