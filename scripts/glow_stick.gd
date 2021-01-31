extends RigidBody2D

export(float) var long_throw_force = 640
export(float) var short_throw_force = 160
export(float) var duration = 10

onready var light = $GlowLight
onready var particles = $GlowParticles
onready var _random_colours = [
	Color(0, 1, 0, 1),
	Color(1, 0, 0, 1),
	Color(1, 1, 0, 1),
	Color(0, 0, 1, 1),
	Color(1, 0, 1, 1)
]
onready var _random_gradients = [
	preload("res://assets/glow_stick/green_gradient.tres"),
	preload("res://assets/glow_stick/red_gradient.tres"),
	preload("res://assets/glow_stick/yellow_gradient.tres"),
	preload("res://assets/glow_stick/blue_gradient.tres"),
	preload("res://assets/glow_stick/pink_gradient.tres")
]
const _number_of_colours = 5


func long_throw():
	_throw(long_throw_force)

func short_throw():
	_throw(short_throw_force)

func _throw(impulse):
	var mouse_position = get_viewport().get_mouse_position()
	var dist = Vector2(mouse_position.x - global_position.x, mouse_position.y - global_position.y)
	_set_random_colour()
	_set_world_parent()
	apply_central_impulse(impulse * dist.normalized())


func _process(delta):
	duration -= delta
	if (duration < 1):
		particles.modulate.a = duration

	if (duration < 0):
		queue_free()
		get_parent().remove_child(self)

func _set_world_parent():
	var global_trans = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = global_trans

func _set_random_colour():
	var colour_index = floor(randf() * _number_of_colours)
	particles.process_material.color_ramp = _random_gradients[colour_index]
	light.color = _random_colours[colour_index]
