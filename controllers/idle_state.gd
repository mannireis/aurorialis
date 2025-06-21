class_name IdlePlayerState

extends PlayerMovementState

@export var SPEED : float = 5
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25

func enter(previous_state) -> void:
	ANIMATION.pause()

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELARATION)
	PLAYER.update_velocity()
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
