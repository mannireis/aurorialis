extends CharacterBody3D
class_name Player

# --- Movement ---
@export var SPEED_DEFAULT: float = 5.0
@export var SPEED_SPRINTING: float = 7.0
@export var ACCELERATION: float = 0.1
@export var DECELARATION: float = 0.25
@export_range(1, 10, 0.1) var CROUCH_SPEED: float = 3.0

# --- Camera ---
@export var MOUSE_SENS: float = 0.3
@export var JOYPAD_SENS: float = 2.0
@export var TILT_LOWER_LIMIT := deg_to_rad(-90)
@export var TILT_UPPER_LIMIT := deg_to_rad(90)
@export var CAMERA_CONTROLLER: Camera3D

# --- Misc ---
@export var ANIMATIONPLAYER: AnimationPlayer
@export var CROUCH_SHAPECAST: Node3D

# --- Internal ---
var _mouse_input: bool = false
var _rotation_input: float = 0.0
var _tilt_input: float = 0.0
var _mouse_rotation: Vector3 = Vector3.ZERO
var _speed: float = SPEED_DEFAULT

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CROUCH_SHAPECAST.add_exception($".")
	Global.player = self

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_input = true
		_rotation_input = -event.relative.x * MOUSE_SENS
		_tilt_input = -event.relative.y * MOUSE_SENS

func update_camera(delta):
	# --- Right Stick Controller ---
	var joy_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var joy_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	if abs(joy_x) > 0.1:
		_rotation_input += -joy_x * JOYPAD_SENS
	if abs(joy_y) > 0.1:
		_tilt_input += -joy_y * JOYPAD_SENS

	# --- Apply rotation ---
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta

	var player_rot = Vector3(0, _mouse_rotation.y, 0)
	var camera_rot = Vector3(_mouse_rotation.x, 0, 0)

	global_transform.basis = Basis.from_euler(player_rot)
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(camera_rot)
	CAMERA_CONTROLLER.rotation.z = 0

	_rotation_input = 0.0
	_tilt_input = 0.0

func update_gravity(delta):
	if not is_on_floor():
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	else:
		velocity.y = 0.0

func update_input(speed: float, acceleration: float, deceleration: float):
	# --- Left Stick / Keyboard ---
	var input_dir = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("back") - Input.get_action_strength("forward")
	)

	# Add left stick support
	input_dir.x += Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	input_dir.y += Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)

	if input_dir.length() > 1:
		input_dir = input_dir.normalized()

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

func update_velocity():
	move_and_slide()

func set_movement_speed(state: String):
	match state:
		"default":
			_speed = SPEED_DEFAULT
		"sprint":
			_speed = SPEED_SPRINTING
		"crouch":
			_speed = CROUCH_SPEED
