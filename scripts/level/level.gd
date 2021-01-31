extends Node2D

var player_start_pos : Vector2
var player = null

func _ready():
	var start_nodes = get_tree().get_nodes_in_group("start")
	assert(start_nodes.size() == 1, "level is either missing or has too many start nodes")
	player_start_pos = start_nodes[0].position
	
	var goal_nodes = get_tree().get_nodes_in_group("goal")
	assert(goal_nodes.size() == 1, "level is either missing or has too many goal nodes")
	
	initialize()
	
func initialize():
	player = Game.player_class.instance()
	player.position = player_start_pos
	PlayerStats.set_glow_stick_count(10)
	add_child(player)

func reset_level():
	if player:
		player.queue_free()
	initialize()
