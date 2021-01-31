extends KinematicBody2D

signal face_dir_changed(dir)

export(float, 0, 1.0) var friction = 0.2
export(float, 0, 1.0) var acceleration = 0.2
export(float) var anim_move_threshold = 30
export(float) var jump_charge_time = 1.5
export(Vector2) var jump_up_dir = Vector2(0.2,-1)
export(Vector2) var jump_fwd_dir = Vector2(1,-0.7)
export(Vector2) var jump_charge_str_fwd = Vector2(1, 3)
export(Vector2) var jump_charge_str_up = Vector2(1, 3)
export(float) var air_floatiness = 4
export(float) var air_time = 0.8
export(float) var hard_land_threshold = 196
export(float) var hard_land_stun_time = 1.2

var SLOPE_STOP = 2 * Globals.TILE_SIZE
var SLOPE_JUMP_SPEED_THRESHOLD = 1.5 * Globals.TILE_SIZE
var move_speed = 2.3 * Globals.TILE_SIZE
var gravity
var is_grounded = true
var jump_timer = 0
var is_charging_jump = false
var stun_timer = 0
var fall_point = 0

onready var _velocity = Vector2(0, 0)
onready var _is_jumping = false
onready var _ground_ray_casts = $GroundRayCasts
onready var _anim_tree = $AnimationTree
onready var _anim_sprite = $Sprite
onready var _anim_state = _anim_tree.get("parameters/playback")
onready var face_dir = 1
onready var _cliff_detector = $CliffDetector

signal glow_stick_count_changed(count)
const GlowStickProjectile = preload("res://objects/glow_stick/GlowStick.tscn")
onready var throw_node = $ThrowPosition
onready var throw_position_x = throw_node.position.x


func _ready():
	gravity = (2 * air_floatiness * Globals.TILE_SIZE) / pow(air_time, 2)
	jump_charge_str_fwd.x = sqrt(2 * gravity * jump_charge_str_fwd.x * Globals.TILE_SIZE)
	jump_charge_str_fwd.y = sqrt(2 * gravity * jump_charge_str_fwd.y * Globals.TILE_SIZE)
	jump_charge_str_up.x = sqrt(2 * gravity * jump_charge_str_up.x * Globals.TILE_SIZE)
	jump_charge_str_up.y = sqrt(2 * gravity * jump_charge_str_up.y * Globals.TILE_SIZE)


func _process(delta):
	if stun_timer > 0:
		stun_timer -= delta
		
	if (Input.is_action_just_pressed("dbp_escape")):
		get_tree().quit()
	if (Input.is_action_just_pressed("player_fire_1") && PlayerStats.glow_stick_count > 0):
		var glow_stick = GlowStickProjectile.instance()
		throw_node.add_child(glow_stick)
		glow_stick.long_throw()
		PlayerStats.decrease_glow_stick_count()
		_anim_state.travel("throw")
	if (Input.is_action_just_pressed("player_fire_2") && PlayerStats.glow_stick_count > 0):
		var glow_stick = GlowStickProjectile.instance()
		throw_node.add_child(glow_stick)
		glow_stick.short_throw()
		PlayerStats.decrease_glow_stick_count()
		_anim_state.travel("throw")
	if (Input.is_action_just_pressed("cheat_0")):
		PlayerStats.set_glow_stick_count(15)
	update_anim_state()


func _physics_process(delta):
	var was_grounded = is_grounded
	is_grounded = _check_is_grounded()
	if was_grounded and not is_grounded:
		fall_point = global_position.y
	elif not is_grounded:
		fall_point = min(fall_point, global_position.y)
	elif not was_grounded and is_grounded:
		var fall_dist = global_position.y - fall_point
		if fall_dist >= hard_land_threshold:
			stun_timer = hard_land_stun_time
			_velocity = Vector2.ZERO
			_anim_state.travel("landing_hard")
	
	_process_physic_input(delta)
	_velocity = move_and_slide(_velocity, Vector2.UP, SLOPE_STOP)
	_cliff_detector.set_enabled(is_grounded)


func _process_physic_input(delta):
	var move_dir = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	var up_dir = Input.get_action_strength("player_move_up")
	var is_stunned = stun_timer > 0
	if is_grounded and not is_stunned:
		if move_dir != 0 && not is_charging_jump:
			_velocity.x = lerp(_velocity.x, move_dir * move_speed, acceleration)
		else:
			_velocity.x = lerp(_velocity.x, 0, friction)

	_velocity.y += gravity * delta

	var was_jumping = _is_jumping
	if Input.is_action_just_pressed("player_jump") && is_grounded && not is_stunned:
		is_charging_jump = true
		jump_timer = 0
	
	if is_charging_jump && (Input.is_action_just_released("player_jump") || jump_timer >= jump_charge_time):
		is_charging_jump = false
		_is_jumping = true
		
	if is_charging_jump:
		jump_timer += delta
		
	if is_stunned:
		is_charging_jump = false
		jump_timer = 0
		
	if not was_jumping && _is_jumping && not is_stunned:
		var jump_t = clamp(jump_timer / jump_charge_time, 0, 1)
		var jump_dir
		var jump_str
		if abs(up_dir) > abs(move_dir):
			jump_str = lerp(jump_charge_str_up, jump_charge_str_up, up_dir)
			jump_dir = jump_up_dir 
		else:
			jump_str = lerp(jump_charge_str_fwd, jump_charge_str_fwd, move_dir)
			jump_dir = jump_fwd_dir
			
		var jump_force = lerp(jump_str.x, jump_str.y, jump_t)
		jump_dir.x = abs(jump_dir.x) * face_dir
		_velocity = _velocity + jump_dir * jump_force
		jump_timer = 0


func _check_is_grounded():
	for raycast in _ground_ray_casts.get_children():
		if raycast.is_colliding():
			return true
	# Not colliding
	return false


func update_anim_state():
	var is_moving = _velocity.length_squared() >= anim_move_threshold * anim_move_threshold
	_anim_tree["parameters/conditions/IsMoving"] = is_moving and is_grounded
	_anim_tree["parameters/conditions/IsNotMoving"] = not is_moving
#
	var old_flip_h = _anim_sprite.flip_h
	if _anim_sprite.flip_h and _velocity.x > anim_move_threshold or _velocity.x < -anim_move_threshold:
		_anim_sprite.flip_h = _velocity.x < 0
		if _anim_sprite.flip_h:
			throw_node.position.x = -throw_position_x
		else:
			throw_node.position.x = throw_position_x

	if _is_jumping && _velocity.y > 0:
		_is_jumping = false

	if old_flip_h != _anim_sprite.flip_h:
		if _anim_sprite.flip_h:
			face_dir = -1
		else:
			face_dir = 1
		emit_signal("face_dir_changed", face_dir)

	_anim_tree["parameters/conditions/IsChargingJump"] = is_charging_jump
	_anim_tree["parameters/conditions/IsJumping"] = _is_jumping
	_anim_tree["parameters/conditions/IsFalling"] = not is_grounded and not _is_jumping
	_anim_tree["parameters/conditions/IsNotFalling"] = is_grounded and not _is_jumping
