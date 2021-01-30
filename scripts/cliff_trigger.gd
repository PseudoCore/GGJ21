extends RayCast2D

export(PackedScene) var cliff_detection_sound
export(float) var update_time = 0.1

onready var timer = $Timer
var last_collision
var _enabled = false
func _ready():
	last_collision = true
	set_enabled(true)

func set_enabled(enabled):
	if _enabled != enabled:
		_enabled = enabled
		if not enabled:
			timer.stop()
		else:
			last_collision = true
			timer.start(update_time)

func _on_Timer_timeout():
	var is_colliding = is_colliding()
	if not is_colliding and last_collision:
		var sound_instance = cliff_detection_sound.instance()
		get_tree().root.add_child(sound_instance)
		sound_instance.trigger(owner.global_position, owner.face_dir)
	last_collision = is_colliding


func _on_Player_face_dir_changed(dir):
	position.x = abs(position.x) * dir
