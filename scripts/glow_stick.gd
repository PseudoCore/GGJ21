extends RigidBody2D

export(float) var long_throw_force = 640
export(float) var short_throw_force = 160
export(float) var duration = 10

onready var particles = $GlowParticles

func long_throw():
	_throw(long_throw_force)

func short_throw():
	_throw(short_throw_force)

func _throw(impulse):
	var global_trans = global_transform
	var mouse_position = get_viewport().get_mouse_position()
	var dist = Vector2(mouse_position.x - global_position.x, mouse_position.y - global_position.y)
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = global_trans
	apply_central_impulse(impulse * dist.normalized())

func _process(delta):
	duration -= delta
	if (duration < 1):
		particles.modulate.a = duration

	if (duration < 0):
		queue_free()
		get_parent().remove_child(self)
