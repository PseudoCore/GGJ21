extends RigidBody2D

export(float) var throw_force = 640
export(float) var duration = 5

onready var particles = $GlowParticles

func launch(direction):
	var global_trans = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = global_trans
	apply_central_impulse(direction * throw_force)

func _process(delta):
	duration -= delta
	if (duration < 1):
		particles.modulate.a = duration

	if (duration < 0):
		queue_free()
		get_parent().remove_child(self)
