extends Area2D

func _on_Exit_area_entered(area):
	if area.owner.is_in_group("player"):
		Game.load_next_level()
