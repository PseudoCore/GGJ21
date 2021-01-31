extends Control

signal glow_stick_count_changed(count)
signal game_cleared(true)

onready var game_cleared_label = $GameClearedLabel

func _ready():
	PlayerStats.connect("glow_stick_count_changed", self, "_on_glow_stick_count_changed")
	Game.connect("game_cleared", self, "_on_game_cleared")

func _on_glow_stick_count_changed(count):
	emit_signal("glow_stick_count_changed", count)

func _on_game_cleared(flag):
	game_cleared_label.visible = true;
