extends Node

export(int) var glow_stick_count = 10

signal glow_stick_count_changed(count)

func set_glow_stick_count(count):
	glow_stick_count = count
	emit_signal("glow_stick_count_changed", count)

func decrease_glow_stick_count():
	set_glow_stick_count(glow_stick_count - 1)
