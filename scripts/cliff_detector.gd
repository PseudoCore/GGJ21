extends AudioStreamPlayer2D

export(float) var delay_per_tile = 0.5
export(AudioStream) var start_sound
export(AudioStream) var end_sound

onready var timer = $Timer
onready var delay_per_distance = delay_per_tile * (1 / 64.0)
onready var original_pos = position
var cliff_end_pos : Vector2
var kill_on_finish = false

func trigger(trigger_pos, direction):
	global_position = trigger_pos
	original_pos = global_position
	play_stream(start_sound)
	var space_state = get_world_2d().direct_space_state
	var ray_start = original_pos + Vector2(96 * direction, -32)
	var ray_end = ray_start + Vector2(0,512)
	var collision_mask = 1
	var result = space_state.intersect_ray(ray_start, ray_end, [self], collision_mask)
	if result:
		cliff_end_pos = result.position
		var delay = delay_per_distance * (original_pos - cliff_end_pos).length()
		timer.start(delay)
	else:
		kill_on_finish = true

func _process(delta):
	var player = Game.get_player()
	if player:
		var target_delta = original_pos - player.position
		var screen_center = get_viewport_rect().size / 2
		position = screen_center + target_delta


func play_stream(audio_stream):
	stop()
	stream = audio_stream
	play()


func _on_Timer_timeout():
	play_stream(end_sound)


func _on_CliffSound_finished():
	if kill_on_finish or stream == end_sound:
		queue_free()
