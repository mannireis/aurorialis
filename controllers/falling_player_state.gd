class_name FallingPlayerState extends PlayerMovementState

@export var SPEED : float = 3
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25

func enter(previous_state) -> void:
	ANIMATION.pause()

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELARATION)
	PLAYER.update_velocity()

	if PLAYER.is_on_floor():
		ANIMATION.play("jump_end")
		transition.emit("IdlePlayerState")

	if PLAYER.is_on_wall() and PLAYER.is_on_floor() == false:
		transition.emit("WallRunningPlayerState")
