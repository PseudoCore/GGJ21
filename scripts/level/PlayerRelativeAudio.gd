extends AudioStreamPlayer2D

export(float) var min_time
export(float) var max_time
onready var original_pos = global_position
onready var timer = $Timer

func _ready():
	timer.wait_time = rand_range(min_time, max_time)

func _on_Timer_timeout():
	timer.wait_time = rand_range(min_time, max_time)
	play()

func _process(delta):
	var player = Game.get_player()
	if player:
		var target_delta = original_pos - player.position
		var screen_center = get_viewport_rect().size / 2
		position = screen_center + target_delta
