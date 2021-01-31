extends Control

signal glow_stick_count_changed(count)

var glow_stick_node

func _ready():
	PlayerStats.connect("glow_stick_count_changed", self, "_on_glow_stick_count_changed")

func _on_glow_stick_count_changed(count):
	emit_signal("glow_stick_count_changed", count)
