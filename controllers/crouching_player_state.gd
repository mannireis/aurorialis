class_name CrouchingPlayerState extends PlayerMovementState

@export var SPEED : float = 3
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25
@export_range(1, 6, 0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCastTop

var RELEASED : bool = false

func enter(previous_state) -> void:
	if previous_state.name != "SlidingPlayerState":
		ANIMATION.play("crouch", -1.0, CROUCH_SPEED)
	elif previous_state.name == "SlidingPlayerState":
		ANIMATION.current_animation = "crouching"
		ANIMATION.seek(1.0, true)

func exit() -> void:
	RELEASED = false

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELARATION)
	PLAYER.update_velocity()

	if Input.is_action_just_released("crouch"):
		uncrouch()
	elif Input.is_action_pressed("crouch") == false and RELEASED == false:
		RELEASED = true
		uncrouch()
	
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")

	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")

func uncrouch():
	if CROUCH_SHAPECAST.is_colliding() == false:
		ANIMATION.play("crouch", -1.0, -CROUCH_SPEED * 1.5,  true)
		if ANIMATION.is_playing():
			await ANIMATION.animation_finished
		transition.emit("IdlePlayerState")
	elif CROUCH_SHAPECAST.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
