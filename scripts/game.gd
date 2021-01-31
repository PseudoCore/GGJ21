extends Node

export(PackedScene) var player_class
export(PoolStringArray) var level_paths

var current_scene = null
var current_level_id = 0

signal game_cleared(flag)

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func get_player():
	return current_scene.player

func reset_level():
	current_scene.call_deferred("reset_level")

func load_next_level():
	current_level_id = current_level_id + 1
	if level_paths.size() > current_level_id:
		var path = level_paths[current_level_id]
		call_deferred("_deferred_goto_scene", path)
	else:
		emit_signal("game_cleared", true)
		current_scene.player.visible = false

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
