extends NinePatchRect

var label

func _ready():
	label = $Label
	label.text = "0"

func _on_Interface_glow_stick_count_changed(count):
	label.text = str(count)
