extends Node

func _ready():
	if not Engine.is_editor_hint():
		$EditorGizmo.queue_free()
