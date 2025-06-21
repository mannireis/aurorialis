class_name IdlePlayerState

extends PlayerMovementState

@export var SPEED : float = 5
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25

func enter() -> void:
	ANIMATION.pause()

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELARATION)
	PLAYER.update_velocity()
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
