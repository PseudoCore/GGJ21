extends Area2D

export(float) var spin_rps = 1

var _spin_speed = spin_rps * PI * 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	rotate(delta * _spin_speed)


func _on_KillZone_area_entered(area):
	if area.owner.is_in_group("player"):
		print("KILLLLLL")
		
