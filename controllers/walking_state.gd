class_name WalkingPlayerState

extends PlayerMovementState

@export var SPEED : float = 5
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 2.2

func exit():
	ANIMATION.speed_scale = 1.0

func enter(previous_state) -> void:
	ANIMATION.play("walking",-1.0,1.0)
	PLAYER._speed = PLAYER.SPEED_DEFAULT

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELARATION)
	PLAYER.update_velocity()

	set_anim_speed(PLAYER.velocity.length())
	if PLAYER.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")

	if Input.is_action_pressed("sprint") and PLAYER.is_on_floor():
		transition.emit("SprintingPlayerState")

	if Input.is_action_just_pressed("crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")

func set_anim_speed(spd):
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
