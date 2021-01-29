extends Node

export(PackedScene) var player_class

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func reset_level():
	current_scene.reset_level()
